package gov.hhs.usas.dss;

import java.util.Calendar;
import java.util.Date;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.batch.core.ExitStatus;
import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

import gov.hhs.usas.dss.whrsc.model.WHRSCDatastoreReport;

@Component
@PropertySource("classpath:whrsc-report.properties")
public class WHRSCReportTasklet implements Tasklet{

	private static final Logger log = LoggerFactory.getLogger(WHRSCReportTasklet.class);
	
	@Autowired
	private Properties properties;
	
	@Autowired
	private WHRSCReportGenerator reportGenerator;

	@Autowired
	private DataSource whrscTargetDataSource;
	
	private WHRSCDatastoreReport report;
	
	public void setReport(WHRSCDatastoreReport whrscReport){
		this.report = whrscReport;
	}
	
	//@SuppressWarnings({ "finally" })
	@Override
	public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {

		String reportXml;
		Date sysDate;
		Date currentDate;
		Calendar c;
		int reportIteration;
		long start;
		long time;
		int errCnt = 0;
		String errMsg;

		
		try {			
			if (report.isRunReport()) {
				start = System.currentTimeMillis();
				
				sysDate = new Date();
				c = Calendar.getInstance();
				c.setTime(sysDate);
				c.add(Calendar.DATE, 1);
				currentDate = c.getTime();
				
				reportXml = reportGenerator.generateReport(report);
				
				if(!Util.isNull(reportXml)) {
					log.info("The report " + report.getReportName() + " retrieved data.");
					if (!Util.isNull(report.getSpTruncate())) {
						reportGenerator.truncateReportTables(whrscTargetDataSource, report);
					}
					if (properties.saveReport()) {
						reportGenerator.saveReportFile(report, reportXml);
					}
					reportGenerator.insertReporttoDB(whrscTargetDataSource, report, reportXml);
				}else {
					log.info("The report " + report.getReportName() + " did not retrieve any data.");
					errCnt++;
				}
				time = System.currentTimeMillis() - start;
				log.info("Time taken for downloading " + report.getReportName() + " data: " + time + "ms");
				
				if (errCnt > 0) {
					errMsg = "The report " + report.getReportName() + " did not retrieve data for " + errCnt + " report iteration(s).";
					log.info(errMsg);
				    contribution.setExitStatus(new ExitStatus(ExitStatus.FAILED.getExitCode(), errMsg));
				    chunkContext.getStepContext().getStepExecution().getJobExecution().getExecutionContext().put(report.getReportName(), properties.getReportErrorMessage());
				} else {
					chunkContext.getStepContext().getStepExecution().getJobExecution().getExecutionContext().put(report.getReportName(), properties.getReportSuccessMessage());
				}
			} else {
				log.info("The report " + report.getReportName() + " is turned off.");
				chunkContext.getStepContext().getStepExecution().getJobExecution().getExecutionContext().put(report.getReportName(), properties.getReportOffMessage());
			}
		}catch (Exception e) {
			log.info(e.getMessage() + "::" + e.getCause());
			contribution.setExitStatus(new ExitStatus(ExitStatus.FAILED.getExitCode(),e.getMessage()));
			chunkContext.getStepContext().getStepExecution().getJobExecution().getExecutionContext().put(report.getReportName(), properties.getReportFailMessage());
		}finally{
			return RepeatStatus.FINISHED;
		}
	}

}
