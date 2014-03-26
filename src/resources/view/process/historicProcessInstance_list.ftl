<!DOCTYPE html>
<#escape x as x?html><html>
<head>
<title><#if request.requestURI?ends_with('/involved')><#if startedBy??&&startedBy>发起的流程<#else>经办的流程</#if><#else>流程列表</#if></title>
</head>
<body>
<#assign columns={
"historicProcessInstance.id":{"alias":"流程ID","width":"100px"},
"processDefinition.name":{"alias":"流程名"},
"historicProcessInstance.startUserId":{"alias","startUser","width":"100px","template":r'<span class="user" data-username="${value}">${statics["org.ironrhino.core.util.ApplicationContextUtils"].getBean("userManager").loadUserByUsername(value)!}</span>'},
"historicProcessInstance.startTime":{"alias":"发起时间","width":"130px"},
"activityName":{"alias":"当前活动","width":"100px","template",r'${(entity.historicActivityInstance.activityName)!}'},
"assignee":{"alias":"当前处理人","width":"100px","template":r'<#if entity.historicActivityInstance??&&entity.historicActivityInstance.assignee?has_content><span class="user" data-username="${entity.historicActivityInstance.assignee}">${statics["org.ironrhino.core.util.ApplicationContextUtils"].getBean("userManager").loadUserByUsername(entity.historicActivityInstance.assignee)!}</span></#if>'},
"historicProcessInstance.endTime":{"width":"130px"}}>

<#assign bottomButtons='
<button type="button" class="btn reload">${action.getText("reload")}</button>
<button type="button" class="btn filter">${action.getText("filter")}</button>
'>
<#assign actionColumnButtons='
<button type="button" class="btn" data-view="view">${action.getText("view")}</button>
<button type="button" class="btn" data-view="trace" data-windowoptions="{\'width\':\'80%\',\'height\':650}">${action.getText("trace")}</button>
'>

<@richtable entityName="historicProcessInstance" action="${getUrl(request.requestURI)}" columns=columns actionColumnButtons=actionColumnButtons bottomButtons=bottomButtons searchable=false celleditable=false/>
<form method="post" class="ajax view criteria form-horizontal" style="display:none;">
<style>
	.row [class*="span"] .control-label{
		width: 200px;
		padding-right: 20px;
	}
</style>
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
		<div class="control-group">
			<label class="control-label" for="criteria_involvedUser">${action.getText('involvedUser')}</label>
			<div class="controls">
				<input id="criteria_involvedUser" type="text" name="criteria.involvedUser"/>
			</div>
		</div>
	</div>
	<div class="span6">
		<div class="control-group">
			<label class="control-label" for="criteria_startedBy">${action.getText('startedBy')}</label>
			<div class="controls">
				<input id="criteria_startedBy" type="text" name="criteria.startedBy"/>
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
<div class="row">
	<div class="span12" style="text-align:center;">
		<button type="submit" class="btn btn-primary">${action.getText('search')}</button> <button type="button" class="btn restore">${action.getText('restore')}</button>
	</div>
</div>
</form>


</body>
</html></#escape>