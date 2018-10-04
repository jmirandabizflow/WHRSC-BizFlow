package gov.hhs.induction;

import java.util.UUID;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.oxm.jaxb.Jaxb2Marshaller;
import org.springframework.stereotype.Service;
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
	@Autowired
	private Jaxb2Marshaller marshaller;
	
	@Value("${request.transactionID.appender}")
	private String transactionIDAppender;
	@Value("${request.transactionOrg}")
	private String transactionOrgIdentifier;
	@Value("${request.systemID}")
    private String systemID;
	@Value("${induction.url}")
    private String inductionURL;
	
	public InductionResponse getInductionResponse(InductionRequest inductionRequest){
		
		
		
		InductPersonRequest inductPersonRequest = createInductPersonRequest(inductionRequest);
		LOG.info(inductPersonRequest.getTransactionHeader().getTransactionID());
		LOG.info(inductPersonRequest.getTransactionHeader().getTransactionOrgIdentifier());
		LOG.info(inductPersonRequest.getTransactionHeader().getSystemID());
		LOG.info(inductPersonRequest.getInductPersonData().get(0).getBaseInductPersonData().getFirstName());
		LOG.info(inductPersonRequest.getInductPersonData().get(0).getBaseInductPersonData().getLastName());
		
		InductionResponse inductionResponse = new InductionResponse();
		InductPersonResponse inductPersonResponse = new InductPersonResponse();
		try {
			inductPersonResponse = (InductPersonResponse) soapConnector.callWebService(inductionURL, inductPersonRequest);
			
			LOG.info("Result Code: "+inductPersonResponse.getInductionResult().get(0).getResultCode());
			LOG.info("Assigned PI (HHSID): "+inductPersonResponse.getInductionResult().get(0).getAssignedPI());
			LOG.info("Result Message: "+inductPersonResponse.getInductionResult().get(0).getResultMessage());
			LOG.info("Failure Detail: "+inductPersonResponse.getInductionResult().get(0).getFailureDetailMessage());
			
			
			inductionResponse.setResultCode(inductPersonResponse.getInductionResult().get(0).getResultCode());
			inductionResponse.setHhsid(inductPersonResponse.getInductionResult().get(0).getAssignedPI());
			inductionResponse.setResultMessage(inductPersonResponse.getInductionResult().get(0).getResultMessage());
			inductionResponse.setFailureDetailMessage(inductPersonResponse.getInductionResult().get(0).getFailureDetailMessage());
		
			LOG.info(inductionResponse.getResultCode());
			LOG.info(inductionResponse.getHhsid());
			LOG.info(inductionResponse.getResultMessage());
			LOG.info(inductionResponse.getFailureDetailMessage());
		
		} catch (SoapFaultClientException soapFault) {
			LOG.info(soapFault.getFaultStringOrReason() + " : " + soapFault.getCause());
			//soapFault.printStackTrace();
			return inductionResponse;
		}catch (Exception e) {
			LOG.info(e.getMessage()+"::"+e.getCause());
			e.printStackTrace();
			return inductionResponse;
		}
		
		return inductionResponse;
	}
	
	private InductPersonRequest createInductPersonRequest(InductionRequest inductionRequest){
		
		InductPersonRequest newInductPersonRequest = new InductPersonRequest();
		
		TransactionHeaderType newTransactionHeader = createTransactionHeader();
		
		InductPersonApplicantDataType newInductPersonData = createInductPersonApplicantData(inductionRequest);
		
		
		
		//add elements to create newInductPersonRequest in the end
		newInductPersonRequest.setTransactionHeader(newTransactionHeader);
		newInductPersonRequest.getInductPersonData().add(newInductPersonData);
		
		return newInductPersonRequest;
	}
	
	private TransactionHeaderType createTransactionHeader(){
		TransactionHeaderType newTransactionHeader = new TransactionHeaderType();
	    String newTransactionID = generateTransactionID();		
		
		newTransactionHeader.setTransactionID(newTransactionID);
		newTransactionHeader.setTransactionOrgIdentifier(transactionOrgIdentifier);
		newTransactionHeader.setSystemID(systemID);
		
		return newTransactionHeader;
	}
	
	private String generateTransactionID(){
		
		String newTransactionID = transactionIDAppender+UUID.randomUUID().toString();		
		return newTransactionID;
	}
	
	private InductPersonApplicantDataType createInductPersonApplicantData(InductionRequest inductionRequest){
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
			foreignNationalIdInfo.setIssuingCountry(inductionRequest.getForeignIDIssuingCountry());
			identificationInformation.setForeignId(foreignNationalIdInfo);
		}		
		
		baseData.setIdentificationInfo(identificationInformation);
		baseData.setDOB(inductionRequest.getDateOfBirth());
		baseData.setEmergencyResponder(inductionRequest.getEmergencyResponder());
		baseData.setOrganization(inductionRequest.getOrganization());
		baseData.setOPDIV(inductionRequest.getOpdiv());
		baseData.setAffiliationCode(inductionRequest.getAffiliationCode());
		baseData.setCredentialCategory(inductionRequest.getCredentialCategory());
		
		newInductPersonApplicantData.setBaseInductPersonData(baseData);
		return newInductPersonApplicantData;
	}

}
