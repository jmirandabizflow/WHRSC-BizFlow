package gov.hhs.induction;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "InductionFormRequest")
public class InductionFormRequest {

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
    @XmlElement(name = "OPDIV", required = true)
    @XmlSchemaType(name = "string")
    private String opdiv;
    @XmlElement(name = "AffiliationCode", required = true)
    @XmlSchemaType(name = "string")
    private String affiliationCode;
    
    
}
