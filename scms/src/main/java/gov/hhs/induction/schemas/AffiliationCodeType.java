//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.11 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2018.10.03 at 10:07:04 PM EDT 
//


package gov.hhs.induction.schemas;

import javax.xml.bind.annotation.XmlEnum;
import javax.xml.bind.annotation.XmlEnumValue;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for AffiliationCodeType.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="AffiliationCodeType"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;maxLength value="20"/&gt;
 *     &lt;enumeration value="AHRQ"/&gt;
 *     &lt;enumeration value="ACF-OA"/&gt;
 *     &lt;enumeration value="ACF-OAS"/&gt;
 *     &lt;enumeration value="ACF-OCC"/&gt;
 *     &lt;enumeration value="ACF-OHS"/&gt;
 *     &lt;enumeration value="ACF-OFA"/&gt;
 *     &lt;enumeration value="ACF-OPA"/&gt;
 *     &lt;enumeration value="ACF-OPRE"/&gt;
 *     &lt;enumeration value="ACF-OCSE"/&gt;
 *     &lt;enumeration value="ACF-ORR"/&gt;
 *     &lt;enumeration value="ACF-ADD"/&gt;
 *     &lt;enumeration value="ACF-ANA"/&gt;
 *     &lt;enumeration value="ACF-OCS"/&gt;
 *     &lt;enumeration value="ACF-OLAB"/&gt;
 *     &lt;enumeration value="ACF-ACYF"/&gt;
 *     &lt;enumeration value="ACF-ORO"/&gt;
 *     &lt;enumeration value="ACF-PCPID"/&gt;
 *     &lt;enumeration value="AOA-OC"/&gt;
 *     &lt;enumeration value="AOA-ESCP"/&gt;
 *     &lt;enumeration value="AOA-OPR"/&gt;
 *     &lt;enumeration value="AOA-CPM"/&gt;
 *     &lt;enumeration value="AOA-OMAR"/&gt;
 *     &lt;enumeration value="AOA-OBF"/&gt;
 *     &lt;enumeration value="AOA-OATS"/&gt;
 *     &lt;enumeration value="AOA-OGM"/&gt;
 *     &lt;enumeration value="AOA-OPPD"/&gt;
 *     &lt;enumeration value="AOA-CPO"/&gt;
 *     &lt;enumeration value="AOA-OCP"/&gt;
 *     &lt;enumeration value="AOA-OER"/&gt;
 *     &lt;enumeration value="AOA-ORO"/&gt;
 *     &lt;enumeration value="AOA-OSP"/&gt;
 *     &lt;enumeration value="AOA-OE"/&gt;
 *     &lt;enumeration value="AOA-IOASA"/&gt;
 *     &lt;enumeration value="AOA-OPDAS"/&gt;
 *     &lt;enumeration value="AOA-CMB"/&gt;
 *     &lt;enumeration value="AOA-CPPE"/&gt;
 *     &lt;enumeration value="AOA-CPO"/&gt;
 *     &lt;enumeration value="AOA-CLASS"/&gt;
 *     &lt;enumeration value="CDC-OD"/&gt;
 *     &lt;enumeration value="CDC-OCSO"/&gt;
 *     &lt;enumeration value="CDC-OCPHP"/&gt;
 *     &lt;enumeration value="CDC-OCOO"/&gt;
 *     &lt;enumeration value="CDC-CDC-W"/&gt;
 *     &lt;enumeration value="CDC-OSI"/&gt;
 *     &lt;enumeration value="CDC-OWCD"/&gt;
 *     &lt;enumeration value="CDC-OEC"/&gt;
 *     &lt;enumeration value="CDC-OCS"/&gt;
 *     &lt;enumeration value="CDC-ODREEO"/&gt;
 *     &lt;enumeration value="CDC-COGH"/&gt;
 *     &lt;enumeration value="CDC-COTPER"/&gt;
 *     &lt;enumeration value="CDC-CCEHIP"/&gt;
 *     &lt;enumeration value="CDC-CCHP"/&gt;
 *     &lt;enumeration value="CDC-NIOSH"/&gt;
 *     &lt;enumeration value="CDC-CCHIS"/&gt;
 *     &lt;enumeration value="CDC-CID"/&gt;
 *     &lt;enumeration value="CDC-ATSDR"/&gt;
 *     &lt;enumeration value="CMS"/&gt;
 *     &lt;enumeration value="CMS-OA"/&gt;
 *     &lt;enumeration value="CMS-OOM"/&gt;
 *     &lt;enumeration value="CMS-OP"/&gt;
 *     &lt;enumeration value="CMS-OEOCR"/&gt;
 *     &lt;enumeration value="CMS-OESS"/&gt;
 *     &lt;enumeration value="CMS-OBIS"/&gt;
 *     &lt;enumeration value="CMS-CBC"/&gt;
 *     &lt;enumeration value="CMS-CMM"/&gt;
 *     &lt;enumeration value="CMS-CMSO"/&gt;
 *     &lt;enumeration value="CMS-OCSQ"/&gt;
 *     &lt;enumeration value="CMS-ORDI"/&gt;
 *     &lt;enumeration value="CMS-OSORA"/&gt;
 *     &lt;enumeration value="CMS-OAGM"/&gt;
 *     &lt;enumeration value="CMS-OIS"/&gt;
 *     &lt;enumeration value="CMS-OFM"/&gt;
 *     &lt;enumeration value="CMS-OL"/&gt;
 *     &lt;enumeration value="CMS-OEA"/&gt;
 *     &lt;enumeration value="CMS-OACT"/&gt;
 *     &lt;enumeration value="CMS-REG01"/&gt;
 *     &lt;enumeration value="CMS-REG02"/&gt;
 *     &lt;enumeration value="CMS-REG03"/&gt;
 *     &lt;enumeration value="CMS-REG04"/&gt;
 *     &lt;enumeration value="CMS-REG05"/&gt;
 *     &lt;enumeration value="CMS-REG06"/&gt;
 *     &lt;enumeration value="CMS-REG07"/&gt;
 *     &lt;enumeration value="CMS-REG08"/&gt;
 *     &lt;enumeration value="CMS-REG09"/&gt;
 *     &lt;enumeration value="CMS-REG10"/&gt;
 *     &lt;enumeration value="FDA"/&gt;
 *     &lt;enumeration value="HRSA"/&gt;
 *     &lt;enumeration value="HRSA-OA"/&gt;
 *     &lt;enumeration value="HRSA-OIT"/&gt;
 *     &lt;enumeration value="HRSA-OL"/&gt;
 *     &lt;enumeration value="HRSA-OC"/&gt;
 *     &lt;enumeration value="HRSA-CQ"/&gt;
 *     &lt;enumeration value="HRSA-OCCA"/&gt;
 *     &lt;enumeration value="HRSA-OEOCR"/&gt;
 *     &lt;enumeration value="HRSA-OPE"/&gt;
 *     &lt;enumeration value="HRSA-OMHHD"/&gt;
 *     &lt;enumeration value="HRSA-AFM"/&gt;
 *     &lt;enumeration value="HRSA-OM"/&gt;
 *     &lt;enumeration value="HRSA-FAM"/&gt;
 *     &lt;enumeration value="HRSA-ORHP"/&gt;
 *     &lt;enumeration value="HRSA-OHIT"/&gt;
 *     &lt;enumeration value="HRSA-BPHC"/&gt;
 *     &lt;enumeration value="HRSA-MCHB"/&gt;
 *     &lt;enumeration value="HRSA-BHPr"/&gt;
 *     &lt;enumeration value="HRSA-HCS"/&gt;
 *     &lt;enumeration value="HRSA-HAB"/&gt;
 *     &lt;enumeration value="HRSA-OPR"/&gt;
 *     &lt;enumeration value="HRSA-BCRS"/&gt;
 *     &lt;enumeration value="SAMHSA"/&gt;
 *     &lt;enumeration value="OS-IOS"/&gt;
 *     &lt;enumeration value="OS-ASA"/&gt;
 *     &lt;enumeration value="OS-ASFR"/&gt;
 *     &lt;enumeration value="OS-ASH"/&gt;
 *     &lt;enumeration value="OS-ASL"/&gt;
 *     &lt;enumeration value="OS-ASPE"/&gt;
 *     &lt;enumeration value="OS-ASPA"/&gt;
 *     &lt;enumeration value="OS-ASPR"/&gt;
 *     &lt;enumeration value="OS-CFBNP"/&gt;
 *     &lt;enumeration value="OS-DAB"/&gt;
 *     &lt;enumeration value="OS-IEA"/&gt;
 *     &lt;enumeration value="OS-OCR"/&gt;
 *     &lt;enumeration value="OS-OD"/&gt;
 *     &lt;enumeration value="OS-OGC"/&gt;
 *     &lt;enumeration value="OS-OGA"/&gt;
 *     &lt;enumeration value="OS-OIG"/&gt;
 *     &lt;enumeration value="OS-OMHA"/&gt;
 *     &lt;enumeration value="OS-ONC"/&gt;
 *     &lt;enumeration value="OS-OASH"/&gt;
 *     &lt;enumeration value="OS-ORD"/&gt;
 *     &lt;enumeration value="OS-PCBE"/&gt;
 *     &lt;enumeration value="NIH"/&gt;
 *     &lt;enumeration value="HQ-OD"/&gt;
 *     &lt;enumeration value="HQ-OMS"/&gt;
 *     &lt;enumeration value="HQ-OEHE"/&gt;
 *     &lt;enumeration value="HQ-OFA"/&gt;
 *     &lt;enumeration value="HQ-ORAP"/&gt;
 *     &lt;enumeration value="HQ-OPHS"/&gt;
 *     &lt;enumeration value="HQ-OIT"/&gt;
 *     &lt;enumeration value="HQ-OCPS"/&gt;
 *     &lt;enumeration value="HQ-ODSCT"/&gt;
 *     &lt;enumeration value="HQ-OTSG"/&gt;
 *     &lt;enumeration value="HQ-OUIHP"/&gt;
 *     &lt;enumeration value="ABR-AO"/&gt;
 *     &lt;enumeration value="ABR-FIELD"/&gt;
 *     &lt;enumeration value="ALK-AO"/&gt;
 *     &lt;enumeration value="ALK-FIELD"/&gt;
 *     &lt;enumeration value="ABQ-AO"/&gt;
 *     &lt;enumeration value="ABQ-FIELD"/&gt;
 *     &lt;enumeration value="BJI-AO"/&gt;
 *     &lt;enumeration value="BJI-FIELD"/&gt;
 *     &lt;enumeration value="BIL-AO"/&gt;
 *     &lt;enumeration value="BIL-FIELD"/&gt;
 *     &lt;enumeration value="CAL-AO"/&gt;
 *     &lt;enumeration value="CAL-FIELD"/&gt;
 *     &lt;enumeration value="NAS-AO"/&gt;
 *     &lt;enumeration value="NAS-FIELD"/&gt;
 *     &lt;enumeration value="NAV-AO"/&gt;
 *     &lt;enumeration value="NAV-FIELD"/&gt;
 *     &lt;enumeration value="OKC-AO"/&gt;
 *     &lt;enumeration value="OKC-FIELD"/&gt;
 *     &lt;enumeration value="PHX-AO"/&gt;
 *     &lt;enumeration value="PHX-FIELD"/&gt;
 *     &lt;enumeration value="POR-AO"/&gt;
 *     &lt;enumeration value="POR-FIELD"/&gt;
 *     &lt;enumeration value="TUS-AO"/&gt;
 *     &lt;enumeration value="TUS-FIELD"/&gt;
 *     &lt;enumeration value="IHS-TRIBAL"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "AffiliationCodeType")
@XmlEnum
public enum AffiliationCodeType {


    /**
     * All STAFFDIVS
     * 
     */
    AHRQ("AHRQ"),

    /**
     * Office of Administration
     * 
     */
    @XmlEnumValue("ACF-OA")
    ACF_OA("ACF-OA"),

    /**
     * Office of the Assistant Secretary
     * 
     */
    @XmlEnumValue("ACF-OAS")
    ACF_OAS("ACF-OAS"),

    /**
     * Office of Child Care
     * 
     */
    @XmlEnumValue("ACF-OCC")
    ACF_OCC("ACF-OCC"),

    /**
     * Office of Head Start
     * 
     */
    @XmlEnumValue("ACF-OHS")
    ACF_OHS("ACF-OHS"),

    /**
     * Office of Family Assistance
     * 
     */
    @XmlEnumValue("ACF-OFA")
    ACF_OFA("ACF-OFA"),

    /**
     * Office of Public Affairs
     * 
     */
    @XmlEnumValue("ACF-OPA")
    ACF_OPA("ACF-OPA"),

    /**
     * Office of Planning Research and Evaluation
     * 
     */
    @XmlEnumValue("ACF-OPRE")
    ACF_OPRE("ACF-OPRE"),

    /**
     * Office of Child Support Enforcement
     * 
     */
    @XmlEnumValue("ACF-OCSE")
    ACF_OCSE("ACF-OCSE"),

    /**
     * Office of Refugee Resettlement
     * 
     */
    @XmlEnumValue("ACF-ORR")
    ACF_ORR("ACF-ORR"),

    /**
     * Administration on Developmental Disabilities
     * 
     */
    @XmlEnumValue("ACF-ADD")
    ACF_ADD("ACF-ADD"),

    /**
     * Administration for Native Americans
     * 
     */
    @XmlEnumValue("ACF-ANA")
    ACF_ANA("ACF-ANA"),

    /**
     * Office of Community Services
     * 
     */
    @XmlEnumValue("ACF-OCS")
    ACF_OCS("ACF-OCS"),

    /**
     * Office of Legislative Affairs and Budget
     * 
     */
    @XmlEnumValue("ACF-OLAB")
    ACF_OLAB("ACF-OLAB"),

    /**
     * Administration on Children, Youth, and Families
     * 
     */
    @XmlEnumValue("ACF-ACYF")
    ACF_ACYF("ACF-ACYF"),

    /**
     * Office of Regional Operations
     * 
     */
    @XmlEnumValue("ACF-ORO")
    ACF_ORO("ACF-ORO"),

    /**
     * President's Committee for People with Intellectual Disabilities
     * 
     */
    @XmlEnumValue("ACF-PCPID")
    ACF_PCPID("ACF-PCPID"),

    /**
     * Office of Communications
     * 
     */
    @XmlEnumValue("AOA-OC")
    AOA_OC("AOA-OC"),

    /**
     * Executive Secretariat and Policy Coordination
     * 
     */
    @XmlEnumValue("AOA-ESCP")
    AOA_ESCP("AOA-ESCP"),

    /**
     * Office of Preparedness and Response
     * 
     */
    @XmlEnumValue("AOA-OPR")
    AOA_OPR("AOA-OPR"),

    /**
     * Center for Policy and Management
     * 
     */
    @XmlEnumValue("AOA-CPM")
    AOA_CPM("AOA-CPM"),

    /**
     * Office of Management Analysis and Resources
     * 
     */
    @XmlEnumValue("AOA-OMAR")
    AOA_OMAR("AOA-OMAR"),

    /**
     * Office of Budget and Finance
     * 
     */
    @XmlEnumValue("AOA-OBF")
    AOA_OBF("AOA-OBF"),

    /**
     * Office of Administrative and Technology Services
     * 
     */
    @XmlEnumValue("AOA-OATS")
    AOA_OATS("AOA-OATS"),

    /**
     * Office of Grants Management
     * 
     */
    @XmlEnumValue("AOA-OGM")
    AOA_OGM("AOA-OGM"),

    /**
     * Office of Planning and Policy Development
     * 
     */
    @XmlEnumValue("AOA-OPPD")
    AOA_OPPD("AOA-OPPD"),

    /**
     * Center for Program Operations
     * 
     */
    @XmlEnumValue("AOA-CPO")
    AOA_CPO("AOA-CPO"),

    /**
     * Office of Core Programs
     * 
     */
    @XmlEnumValue("AOA-OCP")
    AOA_OCP("AOA-OCP"),

    /**
     * Office of Elder Rights
     * 
     */
    @XmlEnumValue("AOA-OER")
    AOA_OER("AOA-OER"),

    /**
     * Office of Regional Operations
     * 
     */
    @XmlEnumValue("AOA-ORO")
    AOA_ORO("AOA-ORO"),

    /**
     * Office of Special Programs
     * 
     */
    @XmlEnumValue("AOA-OSP")
    AOA_OSP("AOA-OSP"),

    /**
     * Office of Evaluation
     * 
     */
    @XmlEnumValue("AOA-OE")
    AOA_OE("AOA-OE"),

    /**
     * Immediate Office of the Assistant Secretary for Aging
     * 
     */
    @XmlEnumValue("AOA-IOASA")
    AOA_IOASA("AOA-IOASA"),

    /**
     * Office of the Principal Deputy Assistant Secretary
     * 
     */
    @XmlEnumValue("AOA-OPDAS")
    AOA_OPDAS("AOA-OPDAS"),

    /**
     * Center for Management and Budget
     * 
     */
    @XmlEnumValue("AOA-CMB")
    AOA_CMB("AOA-CMB"),

    /**
     * Center for Policy, Planning and Evaluation
     * 
     */
    @XmlEnumValue("AOA-CPPE")
    AOA_CPPE("AOA-CPPE"),

    /**
     * Office of Community Living Assistance Services and Supports
     * 
     */
    @XmlEnumValue("AOA-CLASS")
    AOA_CLASS("AOA-CLASS"),

    /**
     * Office of the Director
     * 
     */
    @XmlEnumValue("CDC-OD")
    CDC_OD("CDC-OD"),

    /**
     * Office of Chief Science Officer
     * 
     */
    @XmlEnumValue("CDC-OCSO")
    CDC_OCSO("CDC-OCSO"),

    /**
     * Office of Chief Public Health Practice
     * 
     */
    @XmlEnumValue("CDC-OCPHP")
    CDC_OCPHP("CDC-OCPHP"),

    /**
     * Office of Chief operating Officer
     * 
     */
    @XmlEnumValue("CDC-OCOO")
    CDC_OCOO("CDC-OCOO"),

    /**
     * CDC Washington Office
     * 
     */
    @XmlEnumValue("CDC-CDC-W")
    CDC_CDC_W("CDC-CDC-W"),

    /**
     * Office of Strategy and Innovation
     * 
     */
    @XmlEnumValue("CDC-OSI")
    CDC_OSI("CDC-OSI"),

    /**
     * Office of Workforce and Career Development
     * 
     */
    @XmlEnumValue("CDC-OWCD")
    CDC_OWCD("CDC-OWCD"),

    /**
     * Office of Enterprise Communication
     * 
     */
    @XmlEnumValue("CDC-OEC")
    CDC_OEC("CDC-OEC"),

    /**
     * Office of Chief of Staff
     * 
     */
    @XmlEnumValue("CDC-OCS")
    CDC_OCS("CDC-OCS"),

    /**
     * Office of Dispute Resolution and Equal Opportunity Employment
     * 
     */
    @XmlEnumValue("CDC-ODREEO")
    CDC_ODREEO("CDC-ODREEO"),

    /**
     * Coordinating Office for Global Health
     * 
     */
    @XmlEnumValue("CDC-COGH")
    CDC_COGH("CDC-COGH"),

    /**
     * Coordinating Office for Terrorism Preparedness and Emergency Response
     * 
     */
    @XmlEnumValue("CDC-COTPER")
    CDC_COTPER("CDC-COTPER"),

    /**
     * Coordinating Center for Environmental Health and Injury Prevention
     * 
     */
    @XmlEnumValue("CDC-CCEHIP")
    CDC_CCEHIP("CDC-CCEHIP"),

    /**
     * Coordinating Center for Health Promotion
     * 
     */
    @XmlEnumValue("CDC-CCHP")
    CDC_CCHP("CDC-CCHP"),

    /**
     * National Institute for Occupational Safety and Health
     * 
     */
    @XmlEnumValue("CDC-NIOSH")
    CDC_NIOSH("CDC-NIOSH"),

    /**
     * Coordinating Center for health Information and Service
     * 
     */
    @XmlEnumValue("CDC-CCHIS")
    CDC_CCHIS("CDC-CCHIS"),

    /**
     * Coordinating Center for Infectious Diseases
     * 
     */
    @XmlEnumValue("CDC-CID")
    CDC_CID("CDC-CID"),

    /**
     * Agency for Toxic Substances and Disease Registry
     * 
     */
    @XmlEnumValue("CDC-ATSDR")
    CDC_ATSDR("CDC-ATSDR"),

    /**
     * All STAFFDIVS
     * 
     */
    CMS("CMS"),

    /**
     * Office of the Administrator
     * 
     */
    @XmlEnumValue("CMS-OA")
    CMS_OA("CMS-OA"),

    /**
     * Office of Operations Management
     * 
     */
    @XmlEnumValue("CMS-OOM")
    CMS_OOM("CMS-OOM"),

    /**
     * Office of Policy
     * 
     */
    @XmlEnumValue("CMS-OP")
    CMS_OP("CMS-OP"),

    /**
     * Office of Equal Opportunity and Civil Rights
     * 
     */
    @XmlEnumValue("CMS-OEOCR")
    CMS_OEOCR("CMS-OEOCR"),

    /**
     * Office of E-Health Standards and Services
     * 
     */
    @XmlEnumValue("CMS-OESS")
    CMS_OESS("CMS-OESS"),

    /**
     * Office of Beneficiary Information Services
     * 
     */
    @XmlEnumValue("CMS-OBIS")
    CMS_OBIS("CMS-OBIS"),

    /**
     * Center for Beneficiary Choices
     * 
     */
    @XmlEnumValue("CMS-CBC")
    CMS_CBC("CMS-CBC"),

    /**
     * Center for Medicare Management
     * 
     */
    @XmlEnumValue("CMS-CMM")
    CMS_CMM("CMS-CMM"),

    /**
     * Center for Medicaid and State Operations
     * 
     */
    @XmlEnumValue("CMS-CMSO")
    CMS_CMSO("CMS-CMSO"),

    /**
     * Office of Clinical Standards and Quality
     * 
     */
    @XmlEnumValue("CMS-OCSQ")
    CMS_OCSQ("CMS-OCSQ"),

    /**
     * " Office of Research, Development, and Information"
     * 
     */
    @XmlEnumValue("CMS-ORDI")
    CMS_ORDI("CMS-ORDI"),

    /**
     * Office of Strategic Operations and Regulatory Affairs
     * 
     */
    @XmlEnumValue("CMS-OSORA")
    CMS_OSORA("CMS-OSORA"),

    /**
     * Office of Acquisitions Management and Grants Management
     * 
     */
    @XmlEnumValue("CMS-OAGM")
    CMS_OAGM("CMS-OAGM"),

    /**
     * Office of Information Services
     * 
     */
    @XmlEnumValue("CMS-OIS")
    CMS_OIS("CMS-OIS"),

    /**
     * Office of Financial Management
     * 
     */
    @XmlEnumValue("CMS-OFM")
    CMS_OFM("CMS-OFM"),

    /**
     * Office of Legislation
     * 
     */
    @XmlEnumValue("CMS-OL")
    CMS_OL("CMS-OL"),

    /**
     * Office of External Affairs
     * 
     */
    @XmlEnumValue("CMS-OEA")
    CMS_OEA("CMS-OEA"),

    /**
     * Office of the Actuary
     * 
     */
    @XmlEnumValue("CMS-OACT")
    CMS_OACT("CMS-OACT"),

    /**
     * Region 1
     * 
     */
    @XmlEnumValue("CMS-REG01")
    CMS_REG_01("CMS-REG01"),

    /**
     * Region 2
     * 
     */
    @XmlEnumValue("CMS-REG02")
    CMS_REG_02("CMS-REG02"),

    /**
     * Region 3
     * 
     */
    @XmlEnumValue("CMS-REG03")
    CMS_REG_03("CMS-REG03"),

    /**
     * Region 4
     * 
     */
    @XmlEnumValue("CMS-REG04")
    CMS_REG_04("CMS-REG04"),

    /**
     * Region 5
     * 
     */
    @XmlEnumValue("CMS-REG05")
    CMS_REG_05("CMS-REG05"),

    /**
     * Region 6
     * 
     */
    @XmlEnumValue("CMS-REG06")
    CMS_REG_06("CMS-REG06"),

    /**
     * Region 7
     * 
     */
    @XmlEnumValue("CMS-REG07")
    CMS_REG_07("CMS-REG07"),

    /**
     * Region 8
     * 
     */
    @XmlEnumValue("CMS-REG08")
    CMS_REG_08("CMS-REG08"),

    /**
     * Region 9
     * 
     */
    @XmlEnumValue("CMS-REG09")
    CMS_REG_09("CMS-REG09"),

    /**
     * Region 10
     * 
     */
    @XmlEnumValue("CMS-REG10")
    CMS_REG_10("CMS-REG10"),

    /**
     * All STAFFDIVS
     * 
     */
    FDA("FDA"),

    /**
     * All STAFFDIVS
     * 
     */
    HRSA("HRSA"),

    /**
     * Office of the Administrator
     * 
     */
    @XmlEnumValue("HRSA-OA")
    HRSA_OA("HRSA-OA"),

    /**
     * Office of Information Technology
     * 
     */
    @XmlEnumValue("HRSA-OIT")
    HRSA_OIT("HRSA-OIT"),

    /**
     * Office of Legislation
     * 
     */
    @XmlEnumValue("HRSA-OL")
    HRSA_OL("HRSA-OL"),

    /**
     * Office of Communications
     * 
     */
    @XmlEnumValue("HRSA-OC")
    HRSA_OC("HRSA-OC"),

    /**
     * Center for Quality
     * 
     */
    @XmlEnumValue("HRSA-CQ")
    HRSA_CQ("HRSA-CQ"),

    /**
     * Office of International Health Affairs
     * 
     */
    @XmlEnumValue("HRSA-OCCA")
    HRSA_OCCA("HRSA-OCCA"),

    /**
     * Office of Equal Opportunity and Civil Rights
     * 
     */
    @XmlEnumValue("HRSA-OEOCR")
    HRSA_OEOCR("HRSA-OEOCR"),

    /**
     * Office of Planning and Evaluation
     * 
     */
    @XmlEnumValue("HRSA-OPE")
    HRSA_OPE("HRSA-OPE"),

    /**
     * Office of Minority Health and Health Disparities
     * 
     */
    @XmlEnumValue("HRSA-OMHHD")
    HRSA_OMHHD("HRSA-OMHHD"),

    /**
     * Office of Administration and Financial Management
     * 
     */
    @XmlEnumValue("HRSA-AFM")
    HRSA_AFM("HRSA-AFM"),

    /**
     * Office of Management
     * 
     */
    @XmlEnumValue("HRSA-OM")
    HRSA_OM("HRSA-OM"),

    /**
     * Office of Federal Assistance Management
     * 
     */
    @XmlEnumValue("HRSA-FAM")
    HRSA_FAM("HRSA-FAM"),

    /**
     * Office of Rural Health Policy
     * 
     */
    @XmlEnumValue("HRSA-ORHP")
    HRSA_ORHP("HRSA-ORHP"),

    /**
     * Office of Health Information Technology
     * 
     */
    @XmlEnumValue("HRSA-OHIT")
    HRSA_OHIT("HRSA-OHIT"),

    /**
     * Bureau of Primary Health Care
     * 
     */
    @XmlEnumValue("HRSA-BPHC")
    HRSA_BPHC("HRSA-BPHC"),

    /**
     * Maternal Child Health Bureau
     * 
     */
    @XmlEnumValue("HRSA-MCHB")
    HRSA_MCHB("HRSA-MCHB"),

    /**
     * Bureau Health Professions
     * 
     */
    @XmlEnumValue("HRSA-BHPr")
    HRSA_BH_PR("HRSA-BHPr"),

    /**
     * Healthcare Systems Bureau
     * 
     */
    @XmlEnumValue("HRSA-HCS")
    HRSA_HCS("HRSA-HCS"),

    /**
     * HIV-AIDS Bureau
     * 
     */
    @XmlEnumValue("HRSA-HAB")
    HRSA_HAB("HRSA-HAB"),

    /**
     * Office of Performance Review
     * 
     */
    @XmlEnumValue("HRSA-OPR")
    HRSA_OPR("HRSA-OPR"),

    /**
     * Bureau of Clinician Recruitment and Services
     * 
     */
    @XmlEnumValue("HRSA-BCRS")
    HRSA_BCRS("HRSA-BCRS"),

    /**
     * All STAFFDIVS
     * 
     */
    SAMHSA("SAMHSA"),

    /**
     * Immediate Office of the Secretary
     * 
     */
    @XmlEnumValue("OS-IOS")
    OS_IOS("OS-IOS"),

    /**
     * Assistant Secretary for Administration
     * 
     */
    @XmlEnumValue("OS-ASA")
    OS_ASA("OS-ASA"),

    /**
     * Assistant Secretary for Financial Resources
     * 
     */
    @XmlEnumValue("OS-ASFR")
    OS_ASFR("OS-ASFR"),

    /**
     * Assistant Secretary for Health
     * 
     */
    @XmlEnumValue("OS-ASH")
    OS_ASH("OS-ASH"),

    /**
     * Assistant Secretary for Legislation
     * 
     */
    @XmlEnumValue("OS-ASL")
    OS_ASL("OS-ASL"),

    /**
     * Assistant Secretary for Planning and Evaluation
     * 
     */
    @XmlEnumValue("OS-ASPE")
    OS_ASPE("OS-ASPE"),

    /**
     * Assistant Secretary for Public Affairs
     * 
     */
    @XmlEnumValue("OS-ASPA")
    OS_ASPA("OS-ASPA"),

    /**
     * Assistant Secretary for Preparedness Response
     * 
     */
    @XmlEnumValue("OS-ASPR")
    OS_ASPR("OS-ASPR"),

    /**
     * Center for Faith-Based and Neighborhood Partnerships
     * 
     */
    @XmlEnumValue("OS-CFBNP")
    OS_CFBNP("OS-CFBNP"),

    /**
     * Departmental Appeals Board
     * 
     */
    @XmlEnumValue("OS-DAB")
    OS_DAB("OS-DAB"),

    /**
     * Office of Intergovernmental and External Affairs
     * 
     */
    @XmlEnumValue("OS-IEA")
    OS_IEA("OS-IEA"),

    /**
     * Office for Civil Rights
     * 
     */
    @XmlEnumValue("OS-OCR")
    OS_OCR("OS-OCR"),

    /**
     * Office of Disability
     * 
     */
    @XmlEnumValue("OS-OD")
    OS_OD("OS-OD"),

    /**
     * Office of the General Counsel
     * 
     */
    @XmlEnumValue("OS-OGC")
    OS_OGC("OS-OGC"),

    /**
     * Office of Global Affairs
     * 
     */
    @XmlEnumValue("OS-OGA")
    OS_OGA("OS-OGA"),

    /**
     * Office of Inspector General
     * 
     */
    @XmlEnumValue("OS-OIG")
    OS_OIG("OS-OIG"),

    /**
     * Office of Medicare Hearings and Appeals
     * 
     */
    @XmlEnumValue("OS-OMHA")
    OS_OMHA("OS-OMHA"),

    /**
     * Office of the National Coordinator for Health Information
     * 
     */
    @XmlEnumValue("OS-ONC")
    OS_ONC("OS-ONC"),

    /**
     * Office of the Assistant Secretary for Health
     * 
     */
    @XmlEnumValue("OS-OASH")
    OS_OASH("OS-OASH"),

    /**
     * Office of the Regional Director
     * 
     */
    @XmlEnumValue("OS-ORD")
    OS_ORD("OS-ORD"),

    /**
     * President's Commission on Bioethics
     * 
     */
    @XmlEnumValue("OS-PCBE")
    OS_PCBE("OS-PCBE"),

    /**
     * National Institutes of Health
     * 
     */
    NIH("NIH"),

    /**
     * Headquarters
     * 
     */
    @XmlEnumValue("HQ-OD")
    HQ_OD("HQ-OD"),

    /**
     * Headquarters
     * 
     */
    @XmlEnumValue("HQ-OMS")
    HQ_OMS("HQ-OMS"),

    /**
     * Headquarters
     * 
     */
    @XmlEnumValue("HQ-OEHE")
    HQ_OEHE("HQ-OEHE"),

    /**
     * Headquarters
     * 
     */
    @XmlEnumValue("HQ-OFA")
    HQ_OFA("HQ-OFA"),

    /**
     * Headquarters
     * 
     */
    @XmlEnumValue("HQ-ORAP")
    HQ_ORAP("HQ-ORAP"),

    /**
     * Headquarters
     * 
     */
    @XmlEnumValue("HQ-OPHS")
    HQ_OPHS("HQ-OPHS"),

    /**
     * Headquarters
     * 
     */
    @XmlEnumValue("HQ-OIT")
    HQ_OIT("HQ-OIT"),

    /**
     * Headquarters
     * 
     */
    @XmlEnumValue("HQ-OCPS")
    HQ_OCPS("HQ-OCPS"),

    /**
     * Headquarters
     * 
     */
    @XmlEnumValue("HQ-ODSCT")
    HQ_ODSCT("HQ-ODSCT"),

    /**
     * Headquarters
     * 
     */
    @XmlEnumValue("HQ-OTSG")
    HQ_OTSG("HQ-OTSG"),

    /**
     * Headquarters
     * 
     */
    @XmlEnumValue("HQ-OUIHP")
    HQ_OUIHP("HQ-OUIHP"),

    /**
     * Aberdeen
     * 
     */
    @XmlEnumValue("ABR-AO")
    ABR_AO("ABR-AO"),

    /**
     * Aberdeen
     * 
     */
    @XmlEnumValue("ABR-FIELD")
    ABR_FIELD("ABR-FIELD"),

    /**
     * Alaska
     * 
     */
    @XmlEnumValue("ALK-AO")
    ALK_AO("ALK-AO"),

    /**
     * Alaska
     * 
     */
    @XmlEnumValue("ALK-FIELD")
    ALK_FIELD("ALK-FIELD"),

    /**
     * Albuquerque
     * 
     */
    @XmlEnumValue("ABQ-AO")
    ABQ_AO("ABQ-AO"),

    /**
     * Albuquerque
     * 
     */
    @XmlEnumValue("ABQ-FIELD")
    ABQ_FIELD("ABQ-FIELD"),

    /**
     * Bemidji
     * 
     */
    @XmlEnumValue("BJI-AO")
    BJI_AO("BJI-AO"),

    /**
     * Bemidji
     * 
     */
    @XmlEnumValue("BJI-FIELD")
    BJI_FIELD("BJI-FIELD"),

    /**
     * Billings
     * 
     */
    @XmlEnumValue("BIL-AO")
    BIL_AO("BIL-AO"),

    /**
     * Billings
     * 
     */
    @XmlEnumValue("BIL-FIELD")
    BIL_FIELD("BIL-FIELD"),

    /**
     * California
     * 
     */
    @XmlEnumValue("CAL-AO")
    CAL_AO("CAL-AO"),

    /**
     * California
     * 
     */
    @XmlEnumValue("CAL-FIELD")
    CAL_FIELD("CAL-FIELD"),

    /**
     * Nashville
     * 
     */
    @XmlEnumValue("NAS-AO")
    NAS_AO("NAS-AO"),

    /**
     * Nashville
     * 
     */
    @XmlEnumValue("NAS-FIELD")
    NAS_FIELD("NAS-FIELD"),

    /**
     * Navajo
     * 
     */
    @XmlEnumValue("NAV-AO")
    NAV_AO("NAV-AO"),

    /**
     * Navajo
     * 
     */
    @XmlEnumValue("NAV-FIELD")
    NAV_FIELD("NAV-FIELD"),

    /**
     * Oklahoma City
     * 
     */
    @XmlEnumValue("OKC-AO")
    OKC_AO("OKC-AO"),

    /**
     * Oklahoma City
     * 
     */
    @XmlEnumValue("OKC-FIELD")
    OKC_FIELD("OKC-FIELD"),

    /**
     * Phoenix
     * 
     */
    @XmlEnumValue("PHX-AO")
    PHX_AO("PHX-AO"),

    /**
     * Phoenix
     * 
     */
    @XmlEnumValue("PHX-FIELD")
    PHX_FIELD("PHX-FIELD"),

    /**
     * Portland
     * 
     */
    @XmlEnumValue("POR-AO")
    POR_AO("POR-AO"),

    /**
     * Portland
     * 
     */
    @XmlEnumValue("POR-FIELD")
    POR_FIELD("POR-FIELD"),

    /**
     * Tuscon
     * 
     */
    @XmlEnumValue("TUS-AO")
    TUS_AO("TUS-AO"),

    /**
     * Tuscon
     * 
     */
    @XmlEnumValue("TUS-FIELD")
    TUS_FIELD("TUS-FIELD"),

    /**
     * IHS-TRIBAL
     * 
     */
    @XmlEnumValue("IHS-TRIBAL")
    IHS_TRIBAL("IHS-TRIBAL");
    private final String value;

    AffiliationCodeType(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static AffiliationCodeType fromValue(String v) {
        for (AffiliationCodeType c: AffiliationCodeType.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}
