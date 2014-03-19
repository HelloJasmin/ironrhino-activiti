package com.demo.service;

import java.util.Date;

import org.activiti.engine.RuntimeService;
import org.activiti.engine.delegate.DelegateExecution;
import org.activiti.engine.delegate.ExecutionListener;
import org.ironrhino.security.model.User;
import org.ironrhino.security.service.UserManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.demo.model.Leave;

@Component
@Transactional
public class StartLeaveProcessor implements ExecutionListener {

	private static final long serialVersionUID = -523387540206288280L;

	private LeaveManager leaveManager;

	@Autowired
	RuntimeService runtimeService;

	@Autowired
	UserManager userManager;

	@Override
	public void notify(DelegateExecution delegateExecution) throws Exception {
		String processInstanceId = delegateExecution.getProcessInstanceId();
		Leave leave = new Leave();
		String applyUserId = (String) delegateExecution
				.getVariable("applyUserId");
		if (applyUserId == null)
			throw new NullPointerException("applyUserId is null");
		leave.setUser((User) userManager.loadUserByUsername(applyUserId));
		leave.setProcessInstanceId(processInstanceId);
		leave.setNumber(delegateExecution.getProcessBusinessKey());
		leave.setLeaveType((String) delegateExecution.getVariable("leaveType"));
		leave.setStartTime((Date) delegateExecution.getVariable("startTime"));
		leave.setEndTime((Date) delegateExecution.getVariable("endTime"));
		leave.setReason((String) delegateExecution.getVariable("reason"));
		leaveManager.save(leave);

	}

}
