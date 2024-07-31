public with sharing class EmployeeTriggerHandler {
   
    public calcMinAndMaxAfterInsertAndAfterUndelete(List<Emplyoee> newEmpList) {
       Set<Id> comyIds = new Set<Id>();

        if(!newEmpList.isEmpty()){
            for(Employee emp : newEmpList){
                if(emp.CompanyId!=null)
                comyIds.add(emp.CompanyId);
            }
        }

        Map<Id,Decimal> minMapComp = new Map<Id,Decimal>();
        Map<Id,Decimal> maxMapComp = new Map<Id,Decimal>();
        AggregateResult[] groupedResult = [select CompanyId , MAX(Salary__c) maxSalary,MIN(Salary__c) minSalary from Employee Where CompanyId in :comyIds group by CompanyId];
                if(!groupedResult.isEmpty()){
                    for(AggregateResult ar : groupedResult){
                        if((Decimal)ar.get('maxSalary')!=null)
                        maxMapComp.put((Id)ar.get('CompanyId'),(Decimal)ar.get('maxSalary'));
                        if((Decimal)ar.get('minSalary')!=null)
                        minMapComp.put((Id)ar.get('CompanyId'),(Decimal)ar.get('minSalary'));
                    }
                }
  
         List<Company> newCompyList = new List<Company>();

        if(!newEmpList.isEmpty()){
            for(Employee emp : newEmpList){
                if(emp.Salary__c>maxMapComp.get(emp.CompanyId)){
                    Company c= new Company();
                    c.Id= emp.CompanyId;
                    c.Max_Salary__c =emp.Salary__c;
                    newCompyList.add(c);
                }
                if(emp.Salary__c<minMapComp.get(emp.CompanyId)){
                    Company c= new Company();
                    c.Id= emp.CompanyId;
                    c.Min_Salary__c =emp.Salary__c;
                    newCompyList.add(c);
                }
            }
        }

        if(!newCompyList.isEmpty())
        insert newCompyList;
  } 


  public calcMinAndMaxAfterEmppUpdate(List<Emplyoee> newEmpList,Map<Id,Employee> oldMapEmp) {
    Set<Id> comyIds = new Set<Id>();

    if(!newEmpList.isEmpty()){
        for(Employee emp : newEmpList){
            if(!oldMapEmp.isEmpty()){
                if(emp.CompanyId!=null && emp.CompanyId!=oldMapEmp.get(emp.Id).CompanyId){
                    comyIds.add(emp.CompanyId);
                    comyIds.add(oldMapEmp.get(emp.Id).CompanyId);
                }
                else if(emp.Salary__c!=null && emp.Salary__c!=oldMapEmp.get(emp.Id).Salary__c)
                comyIds.add(emp.CompanyId);
            }
           
        }
    }

    
  }
  }
     /* Collect Company IDs from the trigger context
     Set<Id> companyIds = new Set<Id>();
     if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
         for (Employee__c emp : Trigger.new) {
             if (emp.Company__c != null) {
                 companyIds.add(emp.Company__c);
             }
         }
     }
     if (Trigger.isDelete) {
         for (Employee__c emp : Trigger.old) {
             if (emp.Company__c != null) {
                 companyIds.add(emp.Company__c);
             }
         }
     }
 
     // Update the related Company records
     if (!companyIds.isEmpty()) {
         CompanyTriggerHandler.updateCompanySalaries(companyIds);
     }*/



 /*public class CompanyTriggerHandler {
 
     public static void updateCompanySalaries(Set<Id> companyIds) {
         // Query Employees and calculate min and max salaries for each company
         AggregateResult[] results = [
             SELECT Company__c, MIN(Salary__c) minSalary, MAX(Salary__c) maxSalary
             FROM Employee__c
             WHERE Company__c IN :companyIds
             GROUP BY Company__c
         ];
 
         // Prepare Company records to be updated
         List<Company__c> companiesToUpdate = new List<Company__c>();
         Map<Id, Company__c> companyMap = new Map<Id, Company__c>();
 
         for (AggregateResult result : results) {
             Id companyId = (Id)result.get('Company__c');
             Decimal minSalary = (Decimal)result.get('minSalary');
             Decimal maxSalary = (Decimal)result.get('maxSalary');
 
             Company__c company = new Company__c(
                 Id = companyId,
                 Min_Salary__c = minSalary,
                 Max_Salary__c = maxSalary
             );
 
             companyMap.put(companyId, company);
         }
 
         // Handle the case where a Company may have no Employees
         // This part ensures that even if a Company has no employees, its Min and Max Salary fields are set to null
         for (Id companyId : companyIds) {
             if (!companyMap.containsKey(companyId)) {
                 companyMap.put(companyId, new Company__c(Id = companyId, Min_Salary__c = null, Max_Salary__c = null));
             }
         }
 
         companiesToUpdate = new List<Company__c>(companyMap.values());
 
         // Update Companies
         if (!companiesToUpdate.isEmpty()) {
             update companiesToUpdate;
         }
     }
 } */
 
