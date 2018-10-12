package gov.hhs.induction;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.ws.client.core.support.WebServiceGatewaySupport;

public class SOAPConnector extends WebServiceGatewaySupport {

	private static final Log LOG = LogFactory.getLog(SOAPConnector.class);

	public Object callWebService(String url, Object request){

		LOG.info("Sending Web Service Request using WebServiceTemplate...");
		return getWebServiceTemplate().marshalSendAndReceive(url, request);
	}
}