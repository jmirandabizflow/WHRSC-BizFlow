package gov.hhs.induction;

import org.springframework.ws.client.core.support.WebServiceGatewaySupport;

public class SOAPConnector extends WebServiceGatewaySupport {

	public Object callWebService(String url, Object request){
		System.out.println("SOAPConnector URL: "+ url);
		System.out.println("SOAPConnector REQUEST: "+ request);
		return getWebServiceTemplate().marshalSendAndReceive(url, request);
	}
}