node {
    // Variables to set
    def ProjectPath = "[PATH_TO_CONF]" 
    def OutputDirectory = "${WORKSPACE}"
    def BuildArtifactPath = "${OutputDirectory}/build.zip"
    def ReleaseArtifactPath = "${OutputDirectory}/release.zip"
    def CiDatabaseJdbc = "jdbc:oracle:thin:@//localhost:1521/XE"
    def AcceptanceDatabaseJdbc = "jdbc:oracle:thin:@//localhost:1521/XE"
    def ProductionDatabaseJdbc = "jdbc:oracle:thin:@//localhost:1521/XE"
    def Schema = "XE"
    def User = "hr"				// In a real scenario, you would want to store these safely outside of this script and and pass them in
    def Password = "hr"		// In a real scenario, you would want to store these safely outside of this script and and pass them in
 
    stage ('Checkout') {
        echo "Ensure the pipeline is configured to clean the Jenkins workspace before checkout"
        bat('set')
        deleteDir()
        checkout scm
    }
 
    stage ('Build') {
        echo "Migrating the project to a cleaned CI database; Running Code Analysis for Oracle; Checking for Invalid Objects"
        /* 
        def status
        status = bat returnStatus: true, label: "Build", script: "rca build -P \"${ProjectPath}\" -t ${CiDatabaseJdbc} -o \"${BuildArtifactPath}\" -c -f -v -u ${User} -p ${Password} --IAgreeToTheEula"
         
        echo "Status of Running CI build: $status"
        if (status != 0) { error('Running CI build failed') }
         
        archiveArtifacts allowEmptyArchive: true, artifacts: 'build.zip'
 
		unzip dir: 'build', glob: '', zipFile: 'build.zip'
		archiveArtifacts allowEmptyArchive: true, artifacts: 'build/output/codeAnalysis.html'
		archiveArtifacts allowEmptyArchive: true, artifacts: 'build/output/invalidObjects.csv'
	*/
    }
     
    stage ('Unit Tests') {
        echo "Running utPLSQL database Unit Tests"
         /*
        def status
        status = bat returnStatus: true, label: "Unit Tests", script: "rca test -P \"${ProjectPath}\" -o \"${OutputDirectory}\" -t ${CiDatabaseJdbc} -v -u ${Schema} -p ${Password} --IAgreeToTheEula"
         
        echo "Status of Running RCA test: $status"
        if (status != 0) { error('Running Unit Tests failed') }
             
        status = junit allowEmptyResults: true, testResults: 'test_results.xml'
        echo "Failed JUnit tests: $status.failCount"
        archiveArtifacts allowEmptyArchive: true, artifacts: 'test_results.xml'
 
        zip zipFile: 'code_coverage.zip', archive: true, glob: 'code_coverage.html, code_coverage.html_assets/*'
        archiveArtifacts allowEmptyArchive: true, artifacts: 'code_coverage.zip', fingerprint: true
	*/
    }
     
    stage ('Provision Acceptance') {
        echo "Provisioning a copy of the current Production database"
 	/*
		// There are many ways to provision a copy of Production (e.g. backup/restore or using Schema Compare for Oracle and Data Compare for Oracle)
		// The example documented below is for cloning pluggable databases
		// See some additional details about this on https://documentation.red-gate.com/dso/redgate-change-automation/example-ci-cd-pipelines/Jenkins (scroll to bottom)
        def status
		status = bat returnStatus: true, label: "Drop Acceptance", script: "sqlplus -L -S ${User}/${Password}@[HOST]:[PORT]/[SERVICE NAME] as sysdba @clone-production.sql" 
		// eg sqlplus -L -S sys/${Password}@localhost:1521/orcl as sysdba @clone-production.sql
    	echo "Status of cloning Production: $status"
    	if (status != 0) { error('Cloning production failed') }
 	*/
		/*
		status = bat returnStatus: true, label: "Mask Acceptance", script: "\"C:\\Program Files\\Red Gate\\Data Masker for Oracle 6\\DataMaskerCmdLine.exe\" PARFILE=DataMasker.parfile.txt"
		echo "Status of Masking Acceptance: $status"
    	if (status != 0) { error('Masking Acceptance failed') }
		archiveArtifacts allowEmptyArchive: true, artifacts: '*(Masking Rule Statistics Report)*.txt'
		archiveArtifacts allowEmptyArchive: true, artifacts: '*(Table Statistics Report)*.txt'
		*/
    }
     
    stage ('Prepare Release') {
        echo "Generating deployment script against Acceptance; Doing drift detection; Creating changes report"
         /*
        def status
        status = bat returnStatus: true, label: "Prepare Release", script: "rca release prepare -b \"${BuildArtifactPath}\" -t ${AcceptanceDatabaseJdbc} -o \"${ReleaseArtifactPath}\" -v -u ${User} -p ${Password} -f --IAgreeToTheEula"
         
        echo "Status of Prepare Release: $status"
        if (status != 0) { error('Running Prepare Release failed') }
         
        archiveArtifacts allowEmptyArchive: true, artifacts: 'release.zip'
		unzip dir: 'release', glob: '', zipFile: 'release.zip'
		archiveArtifacts allowEmptyArchive: true, artifacts: 'release/output/changeReport.html'
		archiveArtifacts allowEmptyArchive: true, artifacts: 'release/output/deployment.sql'
		archiveArtifacts allowEmptyArchive: true, artifacts: 'release/output/driftCommitScript.sql'
		archiveArtifacts allowEmptyArchive: true, artifacts: 'release/output/driftRevertScript.sql'
	*/
    }
     
    stage ('Deploy to Acceptance') {
        echo "Deploying release to Acceptance database for user and performance testing"
         /*
        def status
        status = bat returnStatus: true, label: "Deploy to Acceptance", script: "rca release perform -r \"${ReleaseArtifactPath}\" -t ${AcceptanceDatabaseJdbc} -v -u ${User} -p ${Password} --IAgreeToTheEula"
         
        echo "Status of Deploy to Acceptance: $status"
        if (status != 0) { error('Running Deploy to Acceptance failed') }
	*/
    }
     
    stage ('Approval Gate'){
        def message = "Approve release to Production?"
 	
        // wrapping in a time out so it does not block the agent and simply fails the build if there is no user intervention.
        timeout(time: 30, unit: 'MINUTES') {
            def userInput = input(
                id: 'userInput',
                message: "$message",
                parameters: [
                  [$class: 'TextParameterDefinition', defaultValue: 'I Approve The Deployment', description: 'To Proceed, type I Approve The Deployment', name: 'Review deployment artifacts before proceeding']
                ]
            )
 
            if (userInput.indexOf('I Approve The Deployment') == -1) {
                currentBuild.result = 'ABORTED'
                error('Deployment aborted')
            }
        }
    }
     
    stage ('Deploy to Production') {
        echo "Deploying release to Production database"
         /*
        def status
        status = bat returnStatus: true, label: "Deploy to Production", script: "rca release perform -r \"${ReleaseArtifactPath}\" -t ${ProductionDatabaseJdbc} -v -u ${User} -p ${Password} --IAgreeToTheEula"
         
        echo "Status of Deploy to Production: $status"
        if (status != 0) { error('Running Deploy to Production failed') }
	*/
    }
}
