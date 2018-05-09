var contextPath = "/bizflow";
function approveDocument(param) {
	var items = getBizCoveComponent(param.bizcoveid).getSelectedItems();
	if(items)
	{
		if(1==items.length)
		{
            var data = items[0];		
			var procid = data.procid;
			var actseq = data.actseq;
			var bizcoveid = param.bizcoveid;
			$.ajax({
				url: '/bizflow/solutions/whrsc/completerdract.jsp',
				method: 'POST',
				data: {serverid: '0000001001', processid: procid, activityid:actseq, bizcoveid:bizcoveid},
				dataType: 'json',
				cache: false,
				async: false,
				success: function (resultObj){
						if(resultObj.success)
						{
							location.reload();
						}
						else
						{
							alert(resultObj.message, "error");
							//ret = false;
						}
				}
			});
		}
		else
		{
			notify("More than one item cannot be selected for this action. Please select only one item.", "warn");
		}
	}
	else
	{
		notify("In order to proceed with this action, please select at least one item.", "warn");
	}
}
function delDocument(param)
{
	var items = getBizCoveComponent(param.bizcoveid).getSelectedItems();
	if(items)
	{
		if(1==items.length)
		{
			var ret = confirm("Did you intend to delete this document?");
			if(ret==true) {
				var data = items[0];
				var procid = data.procid;
				var bizcoveid = param.bizcoveid;

				//var url = "/bizflow/solutions/whrsc/deleterdr.jsp?processid="+data.procid+"&bizcoveid="+param.bizcoveid+"&_t="+(new Date()).getTime();            
				//$("body").append("<iframe src='" + url + "' style='display:none;'></iframe");
			$.ajax({
				url: '/bizflow/solutions/whrsc/deleterdr.jsp',
				method: 'POST',
				data: {serverid: '0000001001', processid: procid, bizcoveid:bizcoveid},
				dataType: 'json',
				cache: false,
				async: false,
				success: function (resultObj){
						if(resultObj.success)
						{
							location.reload();
						}
						else
						{
							alert(resultObj.message, "error");
							//ret = false;
						}
				}
			});

			}
		}
		else
		{
			notify("More than one item cannot be selected for this action. Please select only one item.", "warn");
		}
	}
	else
	{
		notify("In order to proceed with this action, please select at least one item.", "warn");
	}
}

function viewDocument(param)
{
	var items = getBizCoveComponent(param.bizcoveid).getSelectedItems();
	if(items)
	{
		if(1==items.length)
		{
            var data = items[0];
			//debugger;
			
			var url = contextPath + "/instance/pigetattachfile.jsp?";
			
			url += "PROCESSID=" + data.procid + "&IID=" + data.attachid + "&FILENAME=" + data.isfilename + "&PKIVALUE=N&serverid=" + data.svrid;
			
			$("body").append("<iframe TITLE='hiddenFrame' name='hiddenFrame'  src='" + url + "'  style='display:none;'></iframe");
		}
		else
		{
			notify("More than one item cannot be selected for this action. Please select only one item.", "warn");
		}
	}
	else
	{
		notify("In order to proceed with this action, please select at least one item.", "warn");
	}

}