package org.ironrhino.process.action;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipInputStream;

import javax.servlet.ServletOutputStream;

import org.activiti.engine.HistoryService;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.repository.ProcessDefinitionQuery;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.struts2.ServletActionContext;
import org.ironrhino.core.metadata.Authorize;
import org.ironrhino.core.metadata.AutoConfig;
import org.ironrhino.core.metadata.JsonConfig;
import org.ironrhino.core.model.ResultPage;
import org.ironrhino.core.security.role.UserRole;
import org.ironrhino.core.struts.BaseAction;
import org.ironrhino.process.model.Row;
import org.ironrhino.process.service.ProcessTraceService;
import org.springframework.beans.factory.annotation.Autowired;

@AutoConfig(fileupload = "text/xml,application/zip,application/octet-stream")
@Authorize(ifAnyGranted = UserRole.ROLE_ADMINISTRATOR)
public class ProcessDefinitionAction extends BaseAction {

	private static final long serialVersionUID = 8529576691612260306L;

	@Autowired
	private ProcessTraceService processTraceService;

	@Autowired
	private RepositoryService repositoryService;

	@Autowired
	private HistoryService historyService;

	private File file;

	private String fileFileName;

	private ResultPage<Row> resultPage;

	private String deploymentId;

	private String resourceName;

	private String key;

	private ProcessDefinition processDefinition;

	private List<Map<String, Object>> activities;

	public File getFile() {
		return file;
	}

	public void setFile(File file) {
		this.file = file;
	}

	public String getFileFileName() {
		return fileFileName;
	}

	public void setFileFileName(String fileFileName) {
		this.fileFileName = fileFileName;
	}

	public ResultPage<Row> getResultPage() {
		return resultPage;
	}

	public void setResultPage(ResultPage<Row> resultPage) {
		this.resultPage = resultPage;
	}

	public String getDeploymentId() {
		return deploymentId;
	}

	public void setDeploymentId(String deploymentId) {
		this.deploymentId = deploymentId;
	}

	public String getResourceName() {
		return resourceName;
	}

	public void setResourceName(String resourceName) {
		this.resourceName = resourceName;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public ProcessDefinition getProcessDefinition() {
		return processDefinition;
	}

	public List<Map<String, Object>> getActivities() {
		return activities;
	}

	public String execute() {
		if (resultPage == null)
			resultPage = new ResultPage<Row>();
		ProcessDefinitionQuery query = repositoryService
				.createProcessDefinitionQuery();
		if (StringUtils.isNoneBlank(keyword))
			query.processDefinitionNameLike(keyword);
		if (StringUtils.isNotBlank(key))
			query.processDefinitionKey(key);
		long count = query.count();
		resultPage.setTotalResults(count);
		if (count > 0) {
			List<ProcessDefinition> processDefinitions = query
					.orderByProcessDefinitionKey().asc()
					.orderByProcessDefinitionVersion().desc()
					.listPage(resultPage.getStart(), resultPage.getPageSize());

			List<Row> list = new ArrayList<Row>(processDefinitions.size());
			for (ProcessDefinition pd : processDefinitions) {
				Row row = new Row();
				row.setId(pd.getId());
				row.setProcessDefinition(pd);
				row.setDeployment(repositoryService.createDeploymentQuery()
						.deploymentId(pd.getDeploymentId()).singleResult());
				list.add(row);
			}
			resultPage.setResult(list);
		}
		return LIST;
	}

	public String view() {
		processDefinition = repositoryService.createProcessDefinitionQuery()
				.processDefinitionId(getUid()).singleResult();
		if (processDefinition == null)
			return NOTFOUND;
		return VIEW;
	}

	public String delete() {
		String[] id = getId();
		if (id != null) {
			boolean deletable = true;
			for (String processDefinitionId : id) {
				long count = historyService
						.createHistoricProcessInstanceQuery()
						.processDefinitionId(processDefinitionId).count();
				if (count > 0) {
					deletable = false;
					addActionError(processDefinitionId + " 已经启动过流程了,不能删除!");
					break;
				}
			}
			if (!deletable) {
				return ERROR;
			}
			for (String processDefinitionId : id) {
				deploymentId = repositoryService.createProcessDefinitionQuery()
						.processDefinitionId(processDefinitionId)
						.singleResult().getDeploymentId();
				repositoryService.deleteDeployment(deploymentId, true);
			}
			addActionMessage(getText("delete.success"));
		}
		return SUCCESS;
	}

	public String upload() throws Exception {
		if (file == null || fileFileName == null) {
			addActionError("请上传zip文件或者xml文件");
			return ERROR;
		}
		if (fileFileName.endsWith(".zip")) {
			ZipInputStream zipInputStream = new ZipInputStream(
					new FileInputStream(file));
			repositoryService.createDeployment().name(fileFileName)
					.addZipInputStream(zipInputStream).deploy();
		} else if (fileFileName.endsWith(".xml")
				|| fileFileName.endsWith(".bpmn")) {
			repositoryService.createDeployment().name(fileFileName)
					.addInputStream(fileFileName, new FileInputStream(file))
					.deploy();
		}
		addActionMessage("部署成功");
		return SUCCESS;
	}

	public String download() throws Exception {
		InputStream resourceAsStream = repositoryService.getResourceAsStream(
				deploymentId, resourceName);
		byte[] byteArray = IOUtils.toByteArray(resourceAsStream);
		ServletOutputStream servletOutputStream = ServletActionContext
				.getResponse().getOutputStream();
		servletOutputStream.write(byteArray, 0, byteArray.length);
		servletOutputStream.flush();
		servletOutputStream.close();
		return NONE;
	}

	public String diagram() throws Exception {
		InputStream resourceAsStream = null;
		ProcessDefinition processDefinition = repositoryService
				.createProcessDefinitionQuery().processDefinitionId(getUid())
				.singleResult();
		String resourceName = processDefinition.getDiagramResourceName();
		resourceAsStream = repositoryService.getResourceAsStream(
				processDefinition.getDeploymentId(), resourceName);
		byte[] byteArray = IOUtils.toByteArray(resourceAsStream);
		ServletOutputStream servletOutputStream = ServletActionContext
				.getResponse().getOutputStream();
		servletOutputStream.write(byteArray, 0, byteArray.length);
		servletOutputStream.flush();
		servletOutputStream.close();
		return NONE;
	}

	@JsonConfig(root = "activities")
	public String trace() throws Exception {
		activities = processTraceService.traceProcessDefinition(getUid());
		return JSON;
	}

	public String suspend() throws Exception {
		repositoryService.suspendProcessDefinitionById(getUid());
		return SUCCESS;
	}

	public String activate() throws Exception {
		repositoryService.activateProcessDefinitionById(getUid());
		return SUCCESS;
	}

}