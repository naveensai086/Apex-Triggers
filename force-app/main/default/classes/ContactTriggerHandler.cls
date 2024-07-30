public with sharing class ContactTriggerHandler {
   
    public static void updateTotalContactsAfterContactUpdate(List<Contact> conList , Map<Id,Contact> conOldMap){
        Set<Id> accIds = new Set<Id>();
        if(!conList.isEmpty()){
            for(Contact con : conList){
                if(con.AccountId != conOldMap.get(con.id).AccountId){
                    if(con.AccountId!=null)
                    accIds.add(con.AccountId);
                    if(conOldMap.get(con.id).AccountId!=null)
                    accIds.add(conOldMap.get(con.id).AccountId);
                }
            }
        }
        List<Account> accList = new List<Account>();
        if(!accIds.isEmpty()){  
            for(Account ac :[select id ,Total_Contacts__c ,(select Id from Contacts) from Account where Id =:accIds]){
                System.debug('ACCC'+ac);
                ac.Total_Contacts__c = ac.Contacts.Size();
                accList.add(ac);
            }
        }
        if(!accList.isEmpty())
        update accList;
    }
  
    public static void updateTotalContactsAfterDelete(List<Contact> conList){
        Set<Id> accIds = new Set<Id>();
        if(!conList.isEmpty()){
            for(Contact con :conList){
                if(con.AccountId!=null)
                accIds.add(con.AccountId);
            }
        }
        List<Account> accList = new List<Account>();
        if(!accIds.isEmpty()){  
            for(Account ac :[select id ,Total_Contacts__c ,(select Id from Contacts) from Account where Id =:accIds]){
                System.debug('ACCC'+ac);
                ac.Total_Contacts__c = ac.Contacts.Size();
                accList.add(ac);
            }
        }
        if(!accList.isEmpty())
        update accList;
    }
  
  
    public static void updateTotalContactsAfterInsertAndAfterUndelete(List<Contact> conList){
        Set<Id> accIds = new Set<Id>();
                if(!conList.isEmpty()){
                    for(Contact con :conList){
                        if(con.AccountId!=null)
                        accIds.add(con.AccountId);
                    }
                }
                List<Account> accList = new List<Account>();
                if(!accIds.isEmpty()){  
                    for(Account ac :[select id ,Total_Contacts__c ,(select Id from Contacts) from Account where Id =:accIds]){
                        System.debug('ACCC'+ac);
                        ac.Total_Contacts__c = ac.Contacts.Size();
                        accList.add(ac);
                    }
                }
                if(!accList.isEmpty())
                update accList;
    }

    
   
    public static void updateAccountDesc(List<Contact> conList , Map<Id,Contact> conOldMap){
         Map<Id,Contact> conMap = new Map<Id,Contact>();
        if(!conList.isEmpty()){
            for(Contact con : conList){
                if(con.Description != conOldMap.get(con.id).Description && con.AccountId!=null){
                    conMap.put(con.AccountId,con);
                }
            }
        }
        
        if(!conMap.isEmpty()){
            List<Account> accList = [select Id,Description from Account where Id In :conMap.keySet()];
            List<Account> accListToUpdate = new List<Account>();
            if(!accList.isEmpty()){
                 for(Account ac : accList){
                    ac.Description = conMap.get(ac.Id).Description;
                    accListToUpdate.add(ac);
                 }
            }
    
            if(!accListToUpdate.isEmpty())
            update accListToUpdate;
        }
       
        
    }
}