package gov.hhs.induction;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import gov.hhs.induction.InductionResponse;

/**
 * @author prabhjyot.virdi
 * This class as main controller class for the
 * SCMS SOAP Client application. 
 *
 */
@Controller
@RequestMapping({"/scmsswsc"})//Smart Card Management System SOAP Web Service Client
public class SOAPController
{
	private static final Log LOG = LogFactory.getLog(SOAPController.class);

	@Autowired
	SOAPService soapService;	

	/**
	 * This method gets the induction request for a new applicant 
	 * and sends the response received from Induction web service. 
	 * 
	 * @param inductionRequest - Object with all required parameters for Induction service
	 * @return response object with result code, etc.
	 */
	@RequestMapping(value = "/inductPerson", method = RequestMethod.POST, consumes = MediaType.APPLICATION_XML_VALUE, produces = MediaType.APPLICATION_XML_VALUE)
	@ResponseBody
	public InductionResponse getResponse(@RequestBody InductionRequest inductionRequest)
	{
		LOG.info("CLIENT REQUEST RECEIVED TO INDUCT NEW PERSON.");
		InductionResponse inductionResponse = new InductionResponse();
		if(inductionRequest.getFirstName().isEmpty() || inductionRequest.getLastName().isEmpty()){
			LOG.info("CLIENT REQUEST RECEIVED :: Invalid FirstName and/or LastName.");
			inductionResponse.setResultCode("Failed");
			inductionResponse.setFailureDetailMessage("Invalid FirstName and/or LastName.");
			LOG.info("CLIENT RESPONSE SENT :: Invalid FirstName and/or LastName.");
			return inductionResponse;
		}else{
			LOG.info("CLIENT REQUEST RECEIVED :: " + inductionRequest.getFirstName() + " " + inductionRequest.getLastName());
			inductionResponse = soapService.getInductionResponse(inductionRequest);
			LOG.info("CLIENT RESPONSE SENT :: " + inductionRequest.getFirstName() + " " + inductionRequest.getLastName());
			return inductionResponse;
		}
	}	

}

