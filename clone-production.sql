-- Variables to set
def AcceptancePdb = <AcceptancePdbName>
def ProductionPdb = <ProductionPdbName>
 
-- Change your path to your Acceptance pdb file location
alter system set db_create_file_dest='C:/Oracle/oradata/ORCL/ACCEPTANCE';
 
alter pluggable database $(AcceptancePdb} close immediate;
drop pluggable database $(AcceptancePdb} including datafiles;
 
create pluggable database $(AcceptancePdb}from $(ProductionPdb};
alter pluggable database $(AcceptancePdb} open;
exit;
