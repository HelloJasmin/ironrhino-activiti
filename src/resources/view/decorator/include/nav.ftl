<ul class="nav">
  <li><a href="<@url value="/"/>" class="ajax view">${action.getText("index")}</a></li>
  <@authorize ifAnyGranted="ROLE_ADMINISTRATOR">
  <li><a href="<@url value="/user"/>" class="ajax view">${action.getText("user")}</a></li>
  <li><a href="<@url value="/process/processDefinition"/>" class="ajax view">流程部署</a></li>
  <li><a href="<@url value="/process/processInstance"/>" class="ajax view">流程实例</a></li>
  </@authorize>
  <li class="dropdown">
 	<a href="#" class="dropdown-toggle" data-toggle="dropdown">
      	运行中的流程
    </a>
    <ul class="dropdown-menu">
        <li><a href="<@url value="/process/processInstance/started"/>" class="ajax view">发起的流程</a></li>
  		<li><a href="<@url value="/process/processInstance/involved"/>" class="ajax view">经办的流程</a></li>
    </ul>
  </li>
  <li class="dropdown">
 	<a href="#" class="dropdown-toggle" data-toggle="dropdown">
      	办结的流程
    </a>
    <ul class="dropdown-menu">
        <li><a href="<@url value="/process/historicProcessInstance/started"/>" class="ajax view">发起的流程</a></li>
  		<li><a href="<@url value="/process/historicProcessInstance/involved"/>" class="ajax view">经办的流程</a></li>
    </ul>
  </li>
  <li><a href="<@url value="/process/task"/>" class="ajax view">我的任务</a></li>
  <#assign startableProcessMap=statics['org.ironrhino.core.util.ApplicationContextUtils'].getBean('processService').findStartableProcessMap(authentication('principal').username)>
  <#if !startableProcessMap.empty>
  <li class="dropdown">
 	<a href="#" class="dropdown-toggle" data-toggle="dropdown">
      	发起流程
    </a>
    <ul class="dropdown-menu">
    	<#list startableProcessMap.entrySet() as entry>
        <li><a href="<@url value="/process/task/form?processDefinitionKey=${entry.key}"/>" class="ajax view">${entry.value}</a></li>
        </#list>
    </ul>
  </li>
  </#if>
  <@authorize ifAnyGranted="user">
  <li><a href="<@url value="/leave"/>" class="ajax view">我的请假</a></li>
  </@authorize>
</ul>