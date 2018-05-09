<%@ page language="java" import="com.hs.bf.web.remotescripts.*" %>
<%@ page import="com.hs.frmwk.json.JSONObject" %>
<%@ page import="com.hs.bf.web.xslt.resource.ResourceBag" %>
<%@ page import="com.hs.bf.web.beans.*" %>
<%@ page import="com.hs.bf.web.xmlrs.*" %>

<jsp:useBean id="hwSessionInfo" class="com.hs.bf.web.beans.HWSessionInfo" scope="session"/>
<jsp:useBean id="hwSessionFactory" class="com.hs.bf.web.beans.HWSessionFactory" scope="application"/>

<%@ taglib uri="/WEB-INF/bizflow.tld" prefix="bf" %>
<jsp:useBean id="res" class="com.hs.bf.web.xslt.resource.ResourceBag" scope="application"/>

<bf:parameter id="processid" name="processid" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="activityid" name="activityid" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="bizcoveid" name="bizcoveid" value="" valuePattern="NoRiskyValue"/>

<%
	String language = (String) session.getAttribute("Language");
	String charSet = (String) session.getAttribute("LangCharSet");
	String msgError = "SUCCESS";

	if (null != charSet) {
		response.setContentType("application/json; charset=" + charSet);
	}

	JSONObject ret = new JSONObject();
	ret.put("success", true);
		
	try
	{
	
		HWSession hwSession = hwSessionFactory.newInstance();
		int processId = Integer.parseInt(processid);
		int actSeq = Integer.parseInt(activityid);
		hwSession.completeActivity (hwSessionInfo.toString(), hwSessionInfo.get("ServerID"), processId, actSeq);
		
	}
	catch (Exception e)
	{
		ret.put("success", false);
		ret.put("message", e.getMessage());
	}
	out.print(ret.toString());
	
%>