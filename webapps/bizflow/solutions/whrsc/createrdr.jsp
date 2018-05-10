<%@ page language="java" import="com.hs.bf.web.remotescripts.*" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hs.frmwk.json.JSONObject" %>
<%@ page import="com.hs.bf.web.xslt.resource.ResourceBag" %>
<%@ page import="com.hs.bf.web.beans.*" %>
<%@ page import="com.hs.bf.web.xmlrs.*" %>

<jsp:useBean id="hwSessionInfo" class="com.hs.bf.web.beans.HWSessionInfo" scope="session"/>
<jsp:useBean id="hwSessionFactory" class="com.hs.bf.web.beans.HWSessionFactory" scope="application"/>

<%@ taglib uri="/WEB-INF/bizflow.tld" prefix="bf" %>
<jsp:useBean id="res" class="com.hs.bf.web.xslt.resource.ResourceBag" scope="application"/>
<bf:parameter id="serverid" name="serverid" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="processid" name="processid" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="rdrNumber" name="rdrNumber" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="fpl" name="fpl" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="Series" name="Series" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="grade" name="grade" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="payPlan" name="payPlan" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="positionTitle" name="positionTitle" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="program" name="program" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="approverLevel1" name="approverLevel1" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="approverLevel2" name="approverLevel2" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="approverLevel3" name="approverLevel3" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="approverLevel4" name="approverLevel4" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="approverLevel5" name="approverLevel5" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="approverLevel6" name="approverLevel6" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="approverLevel7" name="approverLevel7" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="approverLevel8" name="approverLevel8" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="approverLevel9" name="approverLevel9" value="" valuePattern="NoRiskyValue"/>
<bf:parameter id="approverLevel10" name="approverLevel10" value="" valuePattern="NoRiskyValue"/>

<%
	String language = (String) session.getAttribute("Language");
	String charSet = (String) session.getAttribute("LangCharSet");
	String msgError = "SUCCESS";

	String attachId = "";
	String attachedFileName;
	String downPath ="";
	String fileName = "";
	String category = "";
	String attachDesc = "";

	String chkLevelApprovers = "";
	String levelOfApproval = "";

	String processName = "RDR Approval";
	int processDefinitionID;
	String description ="";
	int instanceFolderID;
	int archiveFolderID;

	if (null != charSet) {
		response.setContentType("application/json; charset=" + charSet);
	}

	JSONObject ret = new JSONObject();
	ret.put("success", true);
		
	try
	{
		
/*
		int processDefinitionID = 661;
		//String processName = "RDR Approval";  
		String description = "RDR Approval Process";
		int instanceFolderID = 327;
		int archiveFolderID = 328;
*/
		HWSession hwSession = hwSessionFactory.newInstance();
		int processId = Integer.parseInt(processid);

		HWFilter hwFilter = new HWFilter();
		hwFilter.setName("HWProcessDefinition");
		hwFilter.addFilter("FolderServerID", "E", hwSessionInfo.get("ServerID"));
		
		InputStream rsDefStream = 
				hwSession.getProcessDefinitions(hwSessionInfo.toString(), hwFilter.toByteArray());
		rsDefStream.close();	
		
		XMLResultSet xrs = new XMLResultSetImpl();
		xrs.setLookupField("NAME");

		xrs.parse(rsDefStream);

		int rowInd = xrs.lookupField("NAME", processName);
		if(rowInd >=0)
		{
			processDefinitionID = Integer.parseInt(xrs.getFieldValueAt(rowInd, "ID"));
			instanceFolderID =  Integer.parseInt(xrs.getFieldValueAt(0,"INSTANCEFOLDERID"));
			archiveFolderID = Integer.parseInt(xrs.getFieldValueAt(0,"ARCHIVEFOLDERID"));
			description = xrs.getFieldValueAt(0,"DESCRIPTION");
		}
		else
		{
			msgError = "Cannot find a process definition ID";
			throw new Exception(msgError);
		}

		HWFilter filter = new HWFilter();
		filter.addFilter("SERVERID", "E", hwSessionInfo.get("SERVERID"));
		filter.addFilter("PROCESSID", "E", Integer.toString(processId));
		InputStream resultStream = null;
		resultStream = hwSession.getAttachments(hwSessionInfo.toString(),filter.toByteArray());
		
		XMLResultSet xrsAttachFile = new XMLResultSetImpl();
		xrsAttachFile.parse(resultStream);
		resultStream.close();

		for(int i=0; i<xrsAttachFile.getRowCount(); i++)
		{
			attachId = xrsAttachFile.getFieldValueAt(i,"ID");
			attachedFileName = xrsAttachFile.getFieldValueAt(i,"DISPLAYNAME");
			fileName = xrsAttachFile.getFieldValueAt(i,"FILENAME");
			downPath = hwSession.downloadAttachment(hwSessionInfo.toString(), hwSessionInfo.get("SERVERID"), processId, Integer.parseInt(attachId), "");
			category =  xrsAttachFile.getFieldValueAt(i,"CATEGORY");
			attachDesc = xrsAttachFile.getFieldValueAt(i,"DESCRIPTION");
			
			boolean needWorkitemRS = false;

			int rowIndex;

			HWInteger processID = new com.hs.bf.web.beans.HWInteger();

			String [] varFilePath = { "" };
			
			XMLResultSet varRS = new XMLResultSetImpl();
			varRS.createResultSet("HWRelData", "HWRELDATUM");
			varRS.addField("SERVERID");
			varRS.addField("PROCESSID");
			varRS.addField("SEQUENCE");
			varRS.addField("VALUETYPE");
			varRS.addField("NAME");
			varRS.addField("VALUE");

			// String type

			/*
			rowIndex = varRS.add();
			varRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
			varRS.setFieldValueAt(rowIndex, "PROCESSID", Integer.toString(processDefinitionID));
			varRS.setFieldValueAt(rowIndex, "SEQUENCE", "0");
			varRS.setFieldValueAt(rowIndex, "VALUETYPE", "S");
			varRS.setFieldValueAt(rowIndex, "NAME", "jobCode");
			varRS.setFieldValueAt(rowIndex, "VALUE", jobCode);
			*/

			rowIndex = varRS.add();
			varRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
			varRS.setFieldValueAt(rowIndex, "PROCESSID", Integer.toString(processDefinitionID));
			varRS.setFieldValueAt(rowIndex, "SEQUENCE", "0");
			varRS.setFieldValueAt(rowIndex, "VALUETYPE", "S");
			varRS.setFieldValueAt(rowIndex, "NAME", "rdrNumber");
			varRS.setFieldValueAt(rowIndex, "VALUE", rdrNumber);

			rowIndex = varRS.add();
			varRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
			varRS.setFieldValueAt(rowIndex, "PROCESSID", Integer.toString(processDefinitionID));
			varRS.setFieldValueAt(rowIndex, "SEQUENCE", "0");
			varRS.setFieldValueAt(rowIndex, "VALUETYPE", "S");
			varRS.setFieldValueAt(rowIndex, "NAME", "fpl");
			varRS.setFieldValueAt(rowIndex, "VALUE", fpl);

			rowIndex = varRS.add();
			varRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
			varRS.setFieldValueAt(rowIndex, "PROCESSID", Integer.toString(processDefinitionID));
			varRS.setFieldValueAt(rowIndex, "SEQUENCE", "0");
			varRS.setFieldValueAt(rowIndex, "VALUETYPE", "S");
			varRS.setFieldValueAt(rowIndex, "NAME", "Series");
			varRS.setFieldValueAt(rowIndex, "VALUE", Series);
			
			rowIndex = varRS.add();
			varRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
			varRS.setFieldValueAt(rowIndex, "PROCESSID", Integer.toString(processDefinitionID));
			varRS.setFieldValueAt(rowIndex, "SEQUENCE", "0");
			varRS.setFieldValueAt(rowIndex, "VALUETYPE", "S");
			varRS.setFieldValueAt(rowIndex, "NAME", "grade");
			varRS.setFieldValueAt(rowIndex, "VALUE", grade);

			rowIndex = varRS.add();
			varRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
			varRS.setFieldValueAt(rowIndex, "PROCESSID", Integer.toString(processDefinitionID));
			varRS.setFieldValueAt(rowIndex, "SEQUENCE", "0");
			varRS.setFieldValueAt(rowIndex, "VALUETYPE", "S");
			varRS.setFieldValueAt(rowIndex, "NAME", "payPlan");
			varRS.setFieldValueAt(rowIndex, "VALUE", payPlan);

			rowIndex = varRS.add();
			varRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
			varRS.setFieldValueAt(rowIndex, "PROCESSID", Integer.toString(processDefinitionID));
			varRS.setFieldValueAt(rowIndex, "SEQUENCE", "0");
			varRS.setFieldValueAt(rowIndex, "VALUETYPE", "S");
			varRS.setFieldValueAt(rowIndex, "NAME", "positionTitle");
			varRS.setFieldValueAt(rowIndex, "VALUE", positionTitle);

			rowIndex = varRS.add();
			varRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
			varRS.setFieldValueAt(rowIndex, "PROCESSID", Integer.toString(processDefinitionID));
			varRS.setFieldValueAt(rowIndex, "SEQUENCE", "0");
			varRS.setFieldValueAt(rowIndex, "VALUETYPE", "S");
			varRS.setFieldValueAt(rowIndex, "NAME", "program");
			varRS.setFieldValueAt(rowIndex, "VALUE", program);

			rowIndex = varRS.add();
			varRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
			varRS.setFieldValueAt(rowIndex, "PROCESSID", Integer.toString(processDefinitionID));
			varRS.setFieldValueAt(rowIndex, "SEQUENCE", "0");
			varRS.setFieldValueAt(rowIndex, "VALUETYPE", "S");
			varRS.setFieldValueAt(rowIndex, "NAME", "documentType");
			varRS.setFieldValueAt(rowIndex, "VALUE", category);

			rowIndex = varRS.add();
			varRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
			varRS.setFieldValueAt(rowIndex, "PROCESSID", Integer.toString(processDefinitionID));
			varRS.setFieldValueAt(rowIndex, "SEQUENCE", "0");
			varRS.setFieldValueAt(rowIndex, "VALUETYPE", "S");
			varRS.setFieldValueAt(rowIndex, "NAME", "docDesc");
			varRS.setFieldValueAt(rowIndex, "VALUE", attachDesc);

			rowIndex = varRS.add();
			varRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
			varRS.setFieldValueAt(rowIndex, "PROCESSID", Integer.toString(processDefinitionID));
			varRS.setFieldValueAt(rowIndex, "SEQUENCE", "0");
			varRS.setFieldValueAt(rowIndex, "VALUETYPE", "S");
			varRS.setFieldValueAt(rowIndex, "NAME", "fileName");
			varRS.setFieldValueAt(rowIndex, "VALUE", fileName);

			
			List<String> lvlAppr = new ArrayList<String>(10);
			lvlAppr.add(approverLevel1);
			lvlAppr.add(approverLevel2);
			lvlAppr.add(approverLevel3);
			lvlAppr.add(approverLevel4);
			lvlAppr.add(approverLevel5);
			lvlAppr.add(approverLevel6);
			lvlAppr.add(approverLevel7);
			lvlAppr.add(approverLevel8);
			lvlAppr.add(approverLevel9);
			lvlAppr.add(approverLevel10);
			
			for(int indxLvl=0;indxLvl<10;indxLvl++) {
				int rindxLvl = indxLvl + 1;
				int tmpLvlApprLength = lvlAppr.get(indxLvl).length();
				
				if(tmpLvlApprLength >0) {
					String splitVal[]= lvlAppr.get(indxLvl).split(",");
					for(int size=0;size < splitVal.length;size++) {
						int rSize = size + 1;
						rowIndex = varRS.add();
						varRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
						varRS.setFieldValueAt(rowIndex, "PROCESSID", Integer.toString(processDefinitionID));
						varRS.setFieldValueAt(rowIndex, "SEQUENCE", "0");
						varRS.setFieldValueAt(rowIndex, "VALUETYPE", "P");
						varRS.setFieldValueAt(rowIndex, "NAME", "#level"+ rindxLvl + "Approver.1." + rSize);
						varRS.setFieldValueAt(rowIndex, "VALUE", "[U]"+ splitVal[size]);
					}
				}
				else {levelOfApproval = Integer.toString(indxLvl);break; }
				
			}
			
					

			rowIndex = varRS.add();
			varRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
			varRS.setFieldValueAt(rowIndex, "PROCESSID", Integer.toString(processDefinitionID));
			varRS.setFieldValueAt(rowIndex, "SEQUENCE", "0");
			varRS.setFieldValueAt(rowIndex, "VALUETYPE", "S");
			varRS.setFieldValueAt(rowIndex, "NAME", "levelOfApproval");
			varRS.setFieldValueAt(rowIndex, "VALUE", levelOfApproval);

			
			String [] attachmentFilePath = { downPath };
			XMLResultSet attachRS = new XMLResultSetImpl();
					
			File attachFile = new File (downPath);
			long fileSize = attachFile.length();

			attachRS.createResultSet ("HWAttachments", "HWATTACHMENT");
			attachRS.addField("SERVERID");
			attachRS.addField("PROCESSID");
			attachRS.addField("ID");
			attachRS.addField("TYPE");
			attachRS.addField("OUTTYPE");
			attachRS.addField("INTYPE");
			attachRS.addField("DIGITALSIGNATURE");
			attachRS.addField("ACTIVITYSEQUENCE");
			attachRS.addField("MAPID");
			//attachRS.addField("CREATIONDATE");
			attachRS.addField("CREATOR");
			attachRS.addField("CREATORNAME");
			attachRS.addField("SIZE");
			attachRS.addField("DISPLAYNAME");
			attachRS.addField("FILENAME");
			attachRS.addField("ACTIVITYNAME");
			attachRS.addField("DMDOCRTYPE");
			attachRS.addField("CATEGORY");
			attachRS.addField("DESCRIPTION");
			
			rowIndex = attachRS.add();
			attachRS.setFieldValueAt(rowIndex, "SERVERID", serverid);
			attachRS.setFieldValueAt(rowIndex, "PROCESSID",	Integer.toString(processDefinitionID));
			attachRS.setFieldValueAt(rowIndex, "ID", "1");
			attachRS.setFieldValueAt(rowIndex, "TYPE", "G");
			attachRS.setFieldValueAt(rowIndex, "OUTTYPE", "N");
			attachRS.setFieldValueAt(rowIndex, "INTYPE", "C");
			attachRS.setFieldValueAt(rowIndex, "DIGITALSIGNATURE", "N");
			attachRS.setFieldValueAt(rowIndex, "ACTIVITYSEQUENCE", "0");
			attachRS.setFieldValueAt(rowIndex, "MAPID", "0");
			//attachRS.setFieldValueAt(rowIndex, "CREATIONDATE", "2001/01/01 00:00:00");
			attachRS.setFieldValueAt(rowIndex, "CREATOR", hwSessionInfo.get("UserID"));
			attachRS.setFieldValueAt(rowIndex, "CREATORNAME", hwSessionInfo.get("Name"));
			attachRS.setFieldValueAt(rowIndex, "SIZE", Long.toString(fileSize));
			attachRS.setFieldValueAt(rowIndex, "DISPLAYNAME",attachedFileName);
			attachRS.setFieldValueAt(rowIndex, "FILENAME", fileName);
			attachRS.setFieldValueAt(rowIndex, "ACTIVITYNAME", "");
			attachRS.setFieldValueAt(rowIndex, "DMDOCRTYPE", "N");
			attachRS.setFieldValueAt(rowIndex, "CATEGORY",category );
			attachRS.setFieldValueAt(rowIndex, "DESCRIPTION",attachDesc);
		
			//HWSession hwSession = hwSessionFactory.newInstance();
			InputStream instanceStream = null;
						instanceStream = hwSession.createProcessInstance(hwSessionInfo.toString(),
								hwSessionInfo.get("SERVERID"),processDefinitionID,processName,description,
								false,false,instanceFolderID,archiveFolderID,
								true,		// sync?
								true,		// start process?
								false,
								"",		// custom ID
								varRS.toByteArray(),
								null, //fileRS,
								attachRS.toByteArray(),
								attachmentFilePath,
								processID);


		}

	
	}
	catch (Exception e)
	{
		ret.put("success", false);
		ret.put("message", e.getMessage());
	}
	out.print(ret.toString());
	
%>