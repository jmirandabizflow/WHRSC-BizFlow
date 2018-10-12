package gov.hhs.induction;

import java.util.UUID;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.ws.client.WebServiceIOException;
import org.springframework.ws.soap.client.SoapFaultClientException;

import gov.hhs.induction.schemas.ForeignNationalIdInfoType;
import gov.hhs.induction.schemas.HHSInductPersonRequiredDataType;
import gov.hhs.induction.schemas.IdentificationInformationType;
import gov.hhs.induction.schemas.InductPersonApplicantDataType;
import gov.hhs.induction.schemas.InductPersonRequest;
import gov.hhs.induction.schemas.InductPersonResponse;
import gov.hhs.induction.schemas.TransactionHeaderType;

@Service
public class SOAPService {

	private static final Log LOG = LogFactory.getLog(SOAPService.class);

	@Autowired
	private SOAPConnector soapConnector;
	@Value("${request.transactionID.appender}")
	private String transactionIDAppender;
	@Value("${request.transactionOrg}")
	private String transactionOrgIdentifier;
	@Value("${request.systemID}")
	private String systemID;
	@Value("${induction.url}")
	private String inductionURL;

	/**
	 * This method prepares Induct Person request using Induction request 
	 * received from end user and calls the Induction web service.
	 * The web service response received maps to Induct Person Response object, using 
	 * which Induction Response is prepared for the end user. The method
	 * also translates the exceptions/errors to be easily understood by the user.
	 * The actual message gets logged along with Transaction ID. 
	 * @param inductionRequest
	 * @return
	 */
	public InductionResponse getInductionResponse(InductionRequest inductionRequest){

		InductionResponse inductionResponse = new InductionResponse();
		InductPersonResponse inductPersonResponse = new InductPersonResponse();
		try {
			InductPersonRequest inductPersonRequest = createInductPersonRequest(inductionRequest);
			LOG.info("INDUCTION SERVICE REQUEST :: " + getInductPersonRequestAsString(inductPersonRequest));

			//Call Induction Web Service to receive Induct Person Response as per WSDL
			inductPersonResponse = (InductPersonResponse) soapConnector.callWebService(inductionURL, inductPersonRequest);

			LOG.info("INDUCTION SERVICE RESPONSE :: " + getInductPersonResponseAsString(inductPersonResponse));

			//Prepare the Client Response
			if(inductPersonResponse.getInductionResult().get(0).getResultCode() != null)
				inductionResponse.setResultCode(inductPersonResponse.getInductionResult().get(0).getResultCode());
			if(inductPersonResponse.getInductionResult().get(0).getAssignedPI() != null)
				inductionResponse.setHhsid(inductPersonResponse.getInductionResult().get(0).getAssignedPI());
			if(inductPersonResponse.getInductionResult().get(0).getResultMessage() != null)
				inductionResponse.setResultMessage(inductPersonResponse.getInductionResult().get(0).getResultMessage());
			if(inductPersonResponse.getInductionResult().get(0).getFailureDetailMessage() != null)
				inductionResponse.setFailureDetailMessage(inductPersonResponse.getInductionResult().get(0).getFailureDetailMessage());

		} catch(DatatypeConfigurationException datatypeConfig){
			LOG.error("NO INDUCTION SERVICE RESPONSE DUE TO " + datatypeConfig.getClass().getSimpleName());
			LOG.error("Exception Stack Trace :: ", datatypeConfig);
			inductionResponse.setResultCode(datatypeConfig.getClass().getSimpleName());
			inductionResponse.setFailureDetailMessage(datatypeConfig.getMessage());
		} catch (SoapFaultClientException soapFault) {
			LOG.error("NO INDUCTION SERVICE RESPONSE DUE TO " + soapFault.getClass().getSimpleName());
			LOG.error(soapFault.getFaultStringOrReason() + " : " + soapFault.getCause(), soapFault);
			inductionResponse.setResultCode(soapFault.getClass().getSimpleName());
			inductionResponse.setFailureDetailMessage(soapFault.getMessage());
		} catch(WebServiceIOException webIOException){
			LOG.error("NO INDUCTION SERVICE RESPONSE DUE TO " + webIOException.getClass().getSimpleName());
			LOG.error("Exception Stack Trace :: ", webIOException);
			inductionResponse.setResultCode(webIOException.getClass().getSimpleName());
			inductionResponse.setFailureDetailMessage(webIOException.getMessage());
		} catch(IllegalArgumentException illegalArg){
			LOG.error("NO INDUCTION SERVICE RESPONSE DUE TO " + illegalArg.getClass().getSimpleName());
			LOG.error("Exception Stack Trace :: ",illegalArg);
			inductionResponse.setResultCode(illegalArg.getClass().getSimpleName());
			inductionResponse.setFailureDetailMessage("Invalid request parameters.");
		} catch (Exception e) {
			LOG.error("NO INDUCTION SERVICE RESPONSE DUE TO " + e.getClass().getSimpleName());
			LOG.error("Exception Stack Trace :: ", e);
			inductionResponse.setResultCode(e.getClass().getSimpleName());
			inductionResponse.setFailureDetailMessage(e.getMessage());
		}finally{
			LOG.info("CLIENT RESPONSE :: " + getInductionResponseAsString(inductionResponse));
			return inductionResponse;
		}
	}

	/**
	 * This method creates the Induct Person request for calling the Induction service.
	 * @param inductionRequest
	 * @return
	 * @throws DatatypeConfigurationException
	 */
	private InductPersonRequest createInductPersonRequest(InductionRequest inductionRequest) throws DatatypeConfigurationException{

		InductPersonRequest newInductPersonRequest = new InductPersonRequest();

		TransactionHeaderType newTransactionHeader = createTransactionHeader();

		InductPersonApplicantDataType newInductPersonData = createInductPersonApplicantData(inductionRequest);

		//add elements to create newInductPersonRequest in the end
		newInductPersonRequest.setTransactionHeader(newTransactionHeader);
		newInductPersonRequest.getInductPersonData().add(newInductPersonData);

		return newInductPersonRequest;
	}

	/**
	 * This method creates the transaction header for Induct Person request.
	 * @return
	 */
	private TransactionHeaderType createTransactionHeader(){
		TransactionHeaderType newTransactionHeader = new TransactionHeaderType();
		String newTransactionID = generateTransactionID();		

		newTransactionHeader.setTransactionID(newTransactionID);
		newTransactionHeader.setTransactionOrgIdentifier(transactionOrgIdentifier);
		newTransactionHeader.setSystemID(systemID);

		return newTransactionHeader;
	}

	/**
	 * This method creates a transaction ID using random number
	 * for transaction header element.
	 * @return
	 */
	private String generateTransactionID(){

		String newTransactionID = transactionIDAppender+UUID.randomUUID().toString();		
		return newTransactionID;
	}

	/**
	 * This method creates the applicant data for Induct Person request.
	 * @param inductionRequest
	 * @return
	 * @throws DatatypeConfigurationException
	 */
	private InductPersonApplicantDataType createInductPersonApplicantData(InductionRequest inductionRequest) throws DatatypeConfigurationException{
		InductPersonApplicantDataType newInductPersonApplicantData = new InductPersonApplicantDataType();
		HHSInductPersonRequiredDataType baseData = new HHSInductPersonRequiredDataType();

		baseData.setPersonSponsored(inductionRequest.isPersonSponsored());
		baseData.setFirstName(inductionRequest.getFirstName());
		baseData.setLastName(inductionRequest.getLastName());

		IdentificationInformationType identificationInformation = new IdentificationInformationType();

		if(!inductionRequest.getSsn().isEmpty())
			identificationInformation.setSSN(inductionRequest.getSsn());
		else if(!inductionRequest.getArn().isEmpty())
			identificationInformation.setARN(inductionRequest.getArn());
		else if(!inductionRequest.getVisaNumber().isEmpty())
			identificationInformation.setVisaNumber(inductionRequest.getVisaNumber());
		else if(!inductionRequest.getForeignIDNumber().isEmpty()){
			ForeignNationalIdInfoType foreignNationalIdInfo = new ForeignNationalIdInfoType();
			foreignNationalIdInfo.setIdNumber(inductionRequest.getForeignIDNumber());

			if(!inductionRequest.getForeignIDIssuingCountryAsString().isEmpty()){
				foreignNationalIdInfo.setIssuingCountry(inductionRequest.getForeignIDIssuingCountry());
				identificationInformation.setForeignId(foreignNationalIdInfo);
			}
		}		

		baseData.setIdentificationInfo(identificationInformation);
		baseData.setDOB(DatatypeFactory.newInstance().newXMLGregorianCalendar(inductionRequest.getDateOfBirth()));
		baseData.setEmergencyResponder(inductionRequest.getEmergencyResponder());
		baseData.setOrganization(inductionRequest.getOrganization());
		baseData.setOPDIV(inductionRequest.getOpdiv());
		baseData.setAffiliationCode(inductionRequest.getAffiliationCode());
		baseData.setCredentialCategory(inductionRequest.getCredentialCategory());

		newInductPersonApplicantData.setBaseInductPersonData(baseData);
		return newInductPersonApplicantData;
	}

	/**
	 * This method converts the InductPersonRequest object into a string format.
	 * @param inductPersonRequest
	 * @return
	 */
	private String getInductPersonRequestAsString(InductPersonRequest inductPersonRequest){
		return "TransactionID: " + inductPersonRequest.getTransactionHeader().getTransactionID() 
				+ " | " + " TransactionOrg: " + inductPersonRequest.getTransactionHeader().getTransactionOrgIdentifier()
				+ " | " + " SystemID: " + inductPersonRequest.getTransactionHeader().getSystemID()
				+ " | " + " FirstName: " + inductPersonRequest.getInductPersonData().get(0).getBaseInductPersonData().getFirstName()
				+ " | " + " LastName: " + inductPersonRequest.getInductPersonData().get(0).getBaseInductPersonData().getLastName();

	}

	/**
	 * This method converts the InductPersonResponse object into a string format.
	 * @param inductPersonResponse
	 * @return
	 */
	private String getInductPersonResponseAsString(InductPersonResponse inductPersonResponse){
		return "Result Code: " + inductPersonResponse.getInductionResult().get(0).getResultCode()
				+ " | " + " Assigned PI (HHSID): " + inductPersonResponse.getInductionResult().get(0).getAssignedPI()
				+ " | " + " Result Message: " + inductPersonResponse.getInductionResult().get(0).getResultMessage()
				+ " | " + " Failure Detail: " + inductPersonResponse.getInductionResult().get(0).getFailureDetailMessage();
	}

	/**
	 * This method converts the InductionResponse object into a string format.
	 * @param inductionResponse
	 * @return
	 */
	private String getInductionResponseAsString(InductionResponse inductionResponse){
		return "Result Code: " + inductionResponse.getResultCode()
				+ " | " + " Assigned PI (HHSID): " + inductionResponse.getHhsid()
				+ " | " + " Result Message: " + inductionResponse.getResultMessage()
				+ " | " + " Failure Detail: " + inductionResponse.getFailureDetailMessage();
	}

}
