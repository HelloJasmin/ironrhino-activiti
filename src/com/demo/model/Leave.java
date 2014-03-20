package com.demo.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.NaturalId;
import org.ironrhino.core.metadata.Authorize;
import org.ironrhino.core.metadata.AutoConfig;
import org.ironrhino.core.metadata.Hidden;
import org.ironrhino.core.metadata.Owner;
import org.ironrhino.core.metadata.Readonly;
import org.ironrhino.core.metadata.Richtable;
import org.ironrhino.core.metadata.UiConfig;
import org.ironrhino.core.model.BaseEntity;
import org.ironrhino.security.model.User;

@Entity
@Table(name = "`leave`")
@AutoConfig
@Owner(propertyName = "user")
@Authorize(ifAnyGranted = UserRole.user)
@Richtable(readonly = @Readonly(true), bottomButtons = "<a class='btn noid' href='<@url value='/process/task/form?processDefinitionKey=leave'/>' rel='richtable'>请假</a> <button type='button' class='btn reload'>${action.getText('reload')}</button> <button type='button' class='btn filter'>${action.getText('filter')}</button>", order = "applyTime desc")
public class Leave extends BaseEntity {

	private static final long serialVersionUID = -3509600479976901201L;

	@ManyToOne(optional = false)
	@JoinColumn(updatable = false)
	@UiConfig(displayOrder = 1, alias = "申请人", hiddenInList = @Hidden(expression = "!Parameters.user??"), hiddenInView = @Hidden(expression = "!Parameters.user??"))
	private User user;

	@NaturalId
	@UiConfig(displayOrder = 2, alias = "编号")
	private String number;

	@UiConfig(displayOrder = 3, alias = "流程", hiddenInView = @Hidden(true), listTemplate = "<a href=\"<@url value='/process/processInstance/view/${value}'/>\" target=\"_blank\">跟踪</a>", hiddenInInput = @Hidden(true))
	private String processInstanceId;

	@UiConfig(displayOrder = 4)
	@Temporal(TemporalType.DATE)
	private Date startTime;

	@UiConfig(displayOrder = 5)
	@Temporal(TemporalType.DATE)
	private Date endTime;

	@UiConfig(displayOrder = 6)
	@Temporal(TemporalType.DATE)
	private Date realityStartTime;

	@UiConfig(displayOrder = 7)
	@Temporal(TemporalType.DATE)
	private Date realityEndTime;

	@UiConfig(displayOrder = 8)
	private Date applyTime = new Date();

	@UiConfig(displayOrder = 9, type = "dictionary", templateName = "leaveType")
	private String leaveType;

	@UiConfig(displayOrder = 10, type = "textarea")
	@Column(length = 4000)
	private String reason;

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getNumber() {
		return number;
	}

	public void setNumber(String number) {
		this.number = number;
	}

	public String getProcessInstanceId() {
		return processInstanceId;
	}

	public void setProcessInstanceId(String processInstanceId) {
		this.processInstanceId = processInstanceId;
	}

	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public Date getRealityStartTime() {
		return realityStartTime;
	}

	public void setRealityStartTime(Date realityStartTime) {
		this.realityStartTime = realityStartTime;
	}

	public Date getRealityEndTime() {
		return realityEndTime;
	}

	public void setRealityEndTime(Date realityEndTime) {
		this.realityEndTime = realityEndTime;
	}

	public Date getApplyTime() {
		return applyTime;
	}

	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}

	public String getLeaveType() {
		return leaveType;
	}

	public void setLeaveType(String leaveType) {
		this.leaveType = leaveType;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

}
