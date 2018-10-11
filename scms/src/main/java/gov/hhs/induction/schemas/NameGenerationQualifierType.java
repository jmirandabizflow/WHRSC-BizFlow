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
 * <p>Java class for NameGenerationQualifierType.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p>
 * <pre>
 * &lt;simpleType name="NameGenerationQualifierType"&gt;
 *   &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string"&gt;
 *     &lt;maxLength value="5"/&gt;
 *     &lt;enumeration value="Jr"/&gt;
 *     &lt;enumeration value="Sr"/&gt;
 *     &lt;enumeration value="I"/&gt;
 *     &lt;enumeration value="II"/&gt;
 *     &lt;enumeration value="III"/&gt;
 *     &lt;enumeration value="IV"/&gt;
 *     &lt;enumeration value="V"/&gt;
 *     &lt;enumeration value="VI"/&gt;
 *     &lt;enumeration value="VII"/&gt;
 *   &lt;/restriction&gt;
 * &lt;/simpleType&gt;
 * </pre>
 * 
 */
@XmlType(name = "NameGenerationQualifierType")
@XmlEnum
public enum NameGenerationQualifierType {

    @XmlEnumValue("Jr")
    JR("Jr"),
    @XmlEnumValue("Sr")
    SR("Sr"),
    I("I"),
    II("II"),
    III("III"),
    IV("IV"),
    V("V"),
    VI("VI"),
    VII("VII");
    private final String value;

    NameGenerationQualifierType(String v) {
        value = v;
    }

    public String value() {
        return value;
    }

    public static NameGenerationQualifierType fromValue(String v) {
        for (NameGenerationQualifierType c: NameGenerationQualifierType.values()) {
            if (c.value.equals(v)) {
                return c;
            }
        }
        throw new IllegalArgumentException(v);
    }

}