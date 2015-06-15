<!DOCTYPE html>
<#escape x as x?html><html>
<head>
<title><#if request.requestURI?ends_with('/involved')><#if startedBy??&&startedBy>发起的流程<#else>经办的流程</#if><#else>流程列表</#if></title>
</head>
<body>
<#assign columns={
"historicProcessInstance.id":{"alias":"流程ID","width":"100px"},
"processDefinition.name":{"alias":"流程名"},
"historicProcessInstance.businessKey":{"alias":"流程业务KEY","width":"100px"},
"historicProcessInstance.startUserId":{"alias","startUser","width":"100px","template":r'<#if value?has_content><span class="user" data-username="${value}">${statics["org.ironrhino.core.util.ApplicationContextUtils"].getBean("userDetailsService").loadUserByUsername(value,true)!}</span></#if>'},
"historicProcessInstance.startTime":{"alias":"发起时间","width":"130px"}}>
<#if !Parameters.finished?? || Parameters.finished != 'true'>
<#assign columns=columns+{
"activityName":{"alias":"当前活动","width":"100px","template",r'${(entity.historicActivityInstance.activityName)!}'},
"assignee":{"alias":"当前处理人","width":"100px","template":r'<#if entity.historicActivityInstance??&&entity.historicActivityInstance.assignee?has_content><span class="user" data-username="${entity.historicActivityInstance.assignee}">${statics["org.ironrhino.core.util.ApplicationContextUtils"].getBean("userDetailsService").loadUserByUsername(entity.historicActivityInstance.assignee,true)!}</span></#if>'}}>
</#if>
<#if !Parameters.finished?? || Parameters.finished == 'true'>
<#assign columns=columns+{"historicProcessInstance.endTime":{"width":"130px"}}>
</#if>
<#assign bottomButtons='<@btn class="reload"/> <@btn class="filter"/>'>
<#assign actionColumnButtons=r'
<@btn view="view"/>
<#if !entity.historicProcessInstance.endTime??>
'+'
<@btn view="trace" windowoptions="{\'width\':\'80%\',\'height\':650}"/>
'+r'
</#if>
'>
<#assign formid='historicProcessInstance_form'>
<#if Parameters.finished??>
<#assign formid=((Parameters.finished=='true')?string('finished','unfinished'))+'_'+formid/>
</#if>
<@richtable formid=formid entityName="historicProcessInstance" action="${getUrl(request.requestURI)}" columns=columns actionColumnButtons=actionColumnButtons bottomButtons=bottomButtons searchable=false celleditable=false/>
<form method="post" class="ajax view criteria form-horizontal" style="display:none;">
<#if !request.requestURI?ends_with('/involved')>
<div class="row">
	<div class="span6">
		<div class="control-group">
			<label class="control-label" for="criteria_processDefinitionId">${action.getText('processDefinitionId')}</label>
			<div class="controls">
				<input id="criteria_processDefinitionId" type="text" name="criteria.processDefinitionId"/>
			</div>
		</div>
	</div>
	<div class="span6">
		<div class="control-group">
			<label class="control-label" for="criteria_processDefinitionKey">${action.getText('processDefinitionKey')}</label>
			<div class="controls">
				<input id="criteria_processDefinitionKey" type="text" name="criteria.processDefinitionKey"/>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="span6">
		<div class="control-group">
			<label class="control-label" for="criteria_processInstanceId">${action.getText('processInstanceId')}</label>
			<div class="controls">
				<input id="criteria_processInstanceId" type="text" name="criteria.processInstanceId"/>
			</div>
		</div>
	</div>
	<div class="span6">
		<div class="control-group">
			<label class="control-label" for="criteria_processInstanceBusinessKey">${action.getText('processInstanceBusinessKey')}</label>
			<div class="controls">
				<input id="criteria_processInstanceBusinessKey" type="text" name="criteria.processInstanceBusinessKey"/>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="span6">
		<div class="control-group listpick" data-options="{'url':'<@url value="/user/pick?columns=username,name&enabled=true"/>','idindex':1,'nameindex':2}">
		<@s.hidden id="criteria_involvedUser" name="criteria.involvedUser" class="listpick-id"/>
		<label class="control-label" for="criteria_involvedUser-control">${action.getText('involvedUser')}</label>
		<div class="controls">
		<span class="listpick-name"></span>
		</div>
		</div>
	</div>
	<div class="span6">
		<div class="control-group listpick" data-options="{'url':'<@url value="/user/pick?columns=username,name&enabled=true"/>','idindex':1,'nameindex':2}">
		<@s.hidden id="criteria_startedBy" name="criteria.startedBy" class="listpick-id"/>
		<label class="control-label" for="criteria_startedBy-control">${action.getText('startedBy')}</label>
		<div class="controls">
		<span class="listpick-name"></span>
		</div>
		</div>
	</div>
</div>
</#if>
<div class="row">
	<div class="span6">
		<div class="control-group">
			<label class="control-label" for="criteria_startedBefore">${action.getText('startedBefore')}</label>
			<div class="controls">
				<input id="criteria_startedBefore" type="text" name="criteria.startedBefore" class="date"/>
			</div>
		</div>
	</div>
	<div class="span6">
		<div class="control-group">
			<label class="control-label" for="criteria_startedAfter">${action.getText('startedAfter')}</label>
			<div class="controls">
				<input id="criteria_startedAfter" type="text" name="criteria.startedAfter" class="date"/>
			</div>
		</div>
	</div>
</div>
<#if !Parameters.finished?? || Parameters.finished == 'true'>
<div class="row">
	<div class="span6">
		<div class="control-group">
			<label class="control-label" for="criteria_finishedBefore">${action.getText('finishedBefore')}</label>
			<div class="controls">
				<input id="criteria_finishedBefore" type="text" name="criteria.finishedBefore" class="date"/>
			</div>
		</div>
	</div>
	<div class="span6">
		<div class="control-group">
			<label class="control-label" for="criteria_finishedAfter">${action.getText('finishedAfter')}</label>
			<div class="controls">
				<input id="criteria_finishedAfter" type="text" name="criteria.finishedAfter" class="date"/>
			</div>
		</div>
	</div>
</div>
</#if>
<div class="row">
	<div class="span12" style="text-align:center;">
		<button type="submit" class="btn btn-primary">${action.getText('search')}</button> <button type="button" class="btn restore">${action.getText('restore')}</button>
	</div>
</div>
</form>


</body>
</html></#escape>