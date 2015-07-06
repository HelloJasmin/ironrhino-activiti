<#assign templateName="/resources/view/process/form/"+processDefinitionKey/>
<#if formKey?has_content>
	<#assign templateName+="_"+formKey/>
</#if>
<#assign templateName+=".buttons.ftl"/>
<@resourcePresentConditional value=templateName>
<#include templateName>
</@resourcePresentConditional>
<@resourcePresentConditional value=templateName negated=true>
	<div class="form-actions">
	<#if submitFormPropertyName?has_content>
	<#if !submitFormPropertyOptions??>
		<#assign submitFormPropertyOptions={}/>
		<#assign fe=formElements[submitFormPropertyName]!/>
		<#if fe.type=='select'>
		<#assign submitFormPropertyOptions=fe.values/>
		<#elseif fe.type=='radio'>
		<#list fe.values.entrySet() as en>
			<#assign submitFormPropertyOptions+={en.key:((fe.label!action.getText(submitFormPropertyName))+action.getText(en.value))}/>
		</#list>
		<#elseif fe.type=='enum'>
		<#list statics[fe.dynamicAttributes['enumType']].values() as en>
			<#assign submitFormPropertyOptions+={en.name():en?string}/>
		</#list>
		</#if>
	</#if>
	<div class="form-actions">
	<#list submitFormPropertyOptions?keys as key>
	<button type="submit" class="btn<#if key?is_first> btn-primary</#if>" formaction="${actionBaseUrl}/submit<#if uid?has_content>/${uid}</#if>?${submitFormPropertyName}=${key?url}">${submitFormPropertyOptions[key]}</button>
	</#list>
	<#else>
	<button type="submit" class="btn btn-primary">${action.getText((historicProcessInstance??)?then('submit','start'))}</button>	
	</#if>
	<span style="margin-left:100px;">
	<button type="button" class="btn toggle-control-group" data-groupclass="comment">备注</button>
	<button type="button" class="btn toggle-control-group" data-groupclass="attachment">附件</button>
	</span>
	</div>
</@resourcePresentConditional>