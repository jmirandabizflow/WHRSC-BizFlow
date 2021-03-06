package gov.hhs.usas.dss;

/*
 * Bean Configuration for multiple datasources 
 * different source and target DBMS 
 * DB configuration properties defined in 
 * application.properties file.
 * Batch meta-data tables created in target db.
 */
import javax.sql.DataSource;

import org.springframework.boot.autoconfigure.jdbc.DataSourceBuilder;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

@Configuration
public class DataSourceConfiguration {

	@Bean(name="whrscDb")
	@Primary
	@ConfigurationProperties(prefix = "whrsc.target.datasource")
	public DataSource whrscTargetDataSource() {
		return DataSourceBuilder.create().build();
	}	

}
