package gov.hhs.induction;

import org.springframework.beans.factory.annotation.Value;

public class InductionSubRequest {

	@Value("${request.personSponsored}")
    private boolean personSponsored;
	@Value("${request.emergencyResponder}")
    private String emergencyResponder;
    @Value("${request.organization}")
    private String organization;
	@Value("${request.credentialCategory}")
    private String credentialCategory;
}
