package gov.hhs.induction;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement(name = "InductionResponse")
public class InductionResponse {

    @XmlElement(name = "ResultCode", required = true)
    private String resultCode;
    @XmlElement(name = "HHSID")
    private String hhsid;
    @XmlElement(name = "ResultMessage")
    private String resultMessage;
    @XmlElement(name = "FailureDetailMessage")
    private String failureDetailMessage;
    
    public InductionResponse() {
		this.resultCode = "";
		this.hhsid = "";
		this.resultMessage = "";
		this.failureDetailMessage = "";
	}
    
	public InductionResponse(String resultCode, String hhsid, String resultMessage, String failureDetailMessage) {
		this.resultCode = resultCode;
		this.hhsid = hhsid;
		this.resultMessage = resultMessage;
		this.failureDetailMessage = failureDetailMessage;
	}

	public String getResultCode() {
		return resultCode;
	}

	public void setResultCode(String resultCode) {
		this.resultCode = resultCode;
	}

	public String getHhsid() {
		return hhsid;
	}

	public void setHhsid(String hhsid) {
		this.hhsid = hhsid;
	}

	public String getResultMessage() {
		return resultMessage;
	}

	public void setResultMessage(String resultMessage) {
		this.resultMessage = resultMessage;
	}

	public String getFailureDetailMessage() {
		return failureDetailMessage;
	}

	public void setFailureDetailMessage(String failureDetailMessage) {
		this.failureDetailMessage = failureDetailMessage;
	}
    
    
}
