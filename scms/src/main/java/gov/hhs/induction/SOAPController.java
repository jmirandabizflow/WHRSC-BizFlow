package gov.hhs.induction;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import gov.hhs.induction.InductionResponse;



@Controller
@RequestMapping({"/scmsswsc"})//Smart Card Management System SOAP Web Service Client
public class SOAPController
{
	@Autowired
	SOAPService soapService;
	
	
	@RequestMapping(value = "/inductPerson", method = RequestMethod.POST, consumes = MediaType.APPLICATION_XML_VALUE, produces = MediaType.APPLICATION_XML_VALUE)
	@ResponseBody
	public InductionResponse getResponse(@RequestBody InductionRequest inductionRequest)
	{
		InductionResponse inductionResponse = new InductionResponse();
		inductionResponse = soapService.getInductionResponse(inductionRequest);
		return inductionResponse;
	}
	
	
	
	/**
	 * This method connects to USA Staffing Cognos
	 * to pull the specific report for a specific Job Request 
	 * Number and returns the report in Cognos XML dataset format
	 * @param reportName
	 * @param requestNumber
	 * @return
	 */
	//@GetMapping(path = "/name/{studentName}", produces = MediaType.APPLICATION_XML_VALUE)
	/*@RequestMapping("/name/{studentName}")
	@ResponseBody
	public StudentDetailsResponse getResponse(@PathVariable("studentName") String studentName)
	{
		//String responseStr = "Hello";
		System.out.println("Student's name: "+ studentName);
		String name = "Sajal";
		Jaxb2Marshaller marshaller = new Jaxb2Marshaller();
		// this is the package name specified in the <generatePackage> specified in
		// pom.xml
		marshaller.setContextPath("gov.hhs.induction.schemas");
    	SOAPConnector soapConnector = new SOAPConnector();
    	soapConnector.setDefaultUri("http://localhost:8080/service/student-details");
    	soapConnector.setMarshaller(marshaller);
    	soapConnector.setUnmarshaller(marshaller);
    	StudentDetailsRequest request = new StudentDetailsRequest();
		request.setName(studentName);
		StudentDetailsResponse response = new StudentDetailsResponse();
		try {
			response = (StudentDetailsResponse) soapConnector.callWebService("http://localhost:8080/service/student-details", request);
			System.out.println("Got Response As below ========= : ");
			System.out.println("Name : "+response.getStudent().getName());
			System.out.println("Standard : "+response.getStudent().getStandard());
			System.out.println("Address : "+response.getStudent().getAddress());
		} catch (SoapFaultClientException soapFault) {
			// TODO Auto-generated catch block
			System.out.println(soapFault.getFaultStringOrReason() + " : " + soapFault.getCause());
			//soapFault.printStackTrace();
		}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return response;
	}*/

	

}

