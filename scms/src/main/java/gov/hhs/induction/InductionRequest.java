package gov.hhs.induction;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;

import org.springframework.beans.factory.annotation.Value;

import gov.hhs.induction.schemas.AffiliationCodeType;
import gov.hhs.induction.schemas.CountryCodeType;
import gov.hhs.induction.schemas.CredentialCategoryType;
import gov.hhs.induction.schemas.OpdivCodeType;
import gov.hhs.induction.schemas.OrganizationCodeType;
import gov.hhs.induction.schemas.YesNoCodeType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "InductionRequest")
public class InductionRequest {
	
	//@XmlElement(name = "PersonSponsored")
	@Value("${request.personSponsored}")
    private String personSponsored;
    @XmlElement(name = "FirstName", required = true)
    private String firstName;
    @XmlElement(name = "LastName", required = true)
    private String lastName;
    @XmlElement(name = "SSN")
    private String ssn;
    @XmlElement(name = "ARN")
    private String arn;
    @XmlElement(name = "VisaNumber")
    private String visaNumber;
    @XmlElement(name = "ForeignIdNumber")
    private String foreignIDNumber;
    @XmlElement(name = "ForeignIdIssuingCountry")
    @XmlSchemaType(name = "string")
    private String foreignIDIssuingCountry;   
    @XmlElement(name = "DOB", required = true)
    @XmlSchemaType(name = "date")
    private XMLGregorianCalendar DateOfBirth;
    //@XmlElement(name = "EmergencyResponder")
    //@XmlSchemaType(name = "string")
    @Value("${request.emergencyResponder}")
    private String emergencyResponder;
    //@XmlElement(name = "Organization")
    //@XmlSchemaType(name = "string")
    @Value("${request.organization}")
    private String organization;
    @XmlElement(name = "OPDIV", required = true)
    @XmlSchemaType(name = "string")
    private String opdiv;
    @XmlElement(name = "AffiliationCode", required = true)
    @XmlSchemaType(name = "string")
    private String affiliationCode;
    //@XmlElement(name = "CredentialCategory")
    //@XmlSchemaType(name = "string")
    @Value("${request.credentialCategory}")
    private String credentialCategory;
    
	public InductionRequest() {
		init();
		/*this.personSponsored = "${request.personSponsored}";
		this.emergencyResponder = "${request.emergencyResponder}";
		this.organization = "${request.organization}";
		this.credentialCategory = "${request.credentialCategory}";*/
		this.firstName = "";
		this.lastName = "";
		this.ssn = "";
		this.arn = "";
		this.visaNumber = "";
		this.foreignIDNumber = "";
		this.foreignIDIssuingCountry = "";
		this.opdiv = "";
		this.affiliationCode = "";
	}
	
	private void init(){
		this.personSponsored = String.valueOf("false");
		this.emergencyResponder = "N";
		this.organization = "HHS";
		this.credentialCategory = "FEDERAL_EMPLOYEE";
	}
	
	
	public InductionRequest(boolean personSponsored, String firstName, String lastName, String ssn, String arn,
			String visaNumber, String foreignIDNumber, String foreignIDIssuingCountry, XMLGregorianCalendar dateOfBirth,
			String emergencyResponder, String organization, String opdiv, String affiliationCode,
			String credentialCategory) {
		this.personSponsored = String.valueOf(personSponsored);
		this.firstName = firstName;
		this.lastName = lastName;
		this.ssn = ssn;
		this.arn = arn;
		this.visaNumber = visaNumber;
		this.foreignIDNumber = foreignIDNumber;
		this.foreignIDIssuingCountry = foreignIDIssuingCountry;
		this.DateOfBirth = dateOfBirth;
		this.emergencyResponder = emergencyResponder;
		this.organization = organization;
		this.opdiv = opdiv;
		this.affiliationCode = affiliationCode;
		this.credentialCategory = credentialCategory;
	}


	public boolean isPersonSponsored() {
		return Boolean.parseBoolean(personSponsored);
	}
	public void setPersonSponsored(boolean personSponsored) {
		this.personSponsored = String.valueOf(personSponsored);
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getSsn() {
		return ssn;
	}
	public void setSsn(String ssn) {
		this.ssn = ssn;
	}
	public String getArn() {
		return arn;
	}
	public void setArn(String arn) {
		this.arn = arn;
	}
	public String getVisaNumber() {
		return visaNumber;
	}
	public void setVisaNumber(String visaNumber) {
		this.visaNumber = visaNumber;
	}
	public String getForeignIDNumber() {
		return foreignIDNumber;
	}
	public void setForeignIDNumber(String foreignIDNumber) {
		this.foreignIDNumber = foreignIDNumber;
	}
	public CountryCodeType getForeignIDIssuingCountry() {
		return CountryCodeType.valueOf(foreignIDIssuingCountry);
	}
	public void setForeignIDIssuingCountry(CountryCodeType foreignIDIssuingCountry) {
		this.foreignIDIssuingCountry = foreignIDIssuingCountry.name();
	}
	public XMLGregorianCalendar getDateOfBirth() {
		return DateOfBirth;
	}
	public void setDob(XMLGregorianCalendar DateOfBirth) {
		this.DateOfBirth = DateOfBirth;
	}
	public YesNoCodeType getEmergencyResponder() {
		return YesNoCodeType.valueOf(emergencyResponder);
	}
	public void setEmergencyResponder(YesNoCodeType emergencyResponder) {
		this.emergencyResponder = emergencyResponder.name();
	}
	public OrganizationCodeType getOrganization() {
		return OrganizationCodeType.valueOf(organization);
	}
	public void setOrganization(OrganizationCodeType organization) {
		this.organization = organization.name();
	}
	public OpdivCodeType getOpdiv() {
		return OpdivCodeType.valueOf(opdiv);
	}
	public void setOpdiv(OpdivCodeType opdiv) {
		this.opdiv = opdiv.name();
	}
	public AffiliationCodeType getAffiliationCode() {
		return AffiliationCodeType.valueOf(affiliationCode);
	}
	public void setAffiliationCode(AffiliationCodeType affiliationCode) {
		this.affiliationCode = affiliationCode.name();
	}
	public CredentialCategoryType getCredentialCategory() {
		return CredentialCategoryType.valueOf(credentialCategory);
	}
	public void setCredentialCategory(CredentialCategoryType credentialCategory) {
		this.credentialCategory = credentialCategory.name();
	}
    
    
}
