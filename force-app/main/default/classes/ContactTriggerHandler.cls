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

   public static void primaryContactCheck(List<Contact> conList,Map<Id,Contact> conOldMap){
   Set<Id> accIds = new Set<Id>();
   if(!conList.isEmpty()){
    for(Contact c:conList){
        if(conOldMap!=null){
             System.debug('In before update Trigger');
            if(c.AccountId!=conOldMap.get(c.Id).AccountId){
                if(c.AccountId!=null)
                accIds.add(c.AccountId);
                if(conOldMap.get(c.Id).AccountId!=null)
                accIds.add(conOldMap.get(c.Id).AccountId);
            }else{
                if(c.Primary_Contact__c!=conOldMap.get(c.Id).Primary_Contact__c){
                    accIds.add(c.AccountId);
                }
            }
        }
        else{
            System.debug('In before Trigger');
            if(c.AccountId!=null)
            accIds.add(c.AccountId);
        }
       
    }
}

    Map<Id,Boolean> checkData = new  Map<Id,Boolean>();
    if(!accIds.isEmpty()){
         System.debug('In Query Acc'+accIds);
    List<Contact> accData = new List<Contact>([select Id,AccountId ,Primary_Contact__c from
                                                         Contact where AccountId IN:accIds and Primary_Contact__c=true]);   
        if(!accData.isEmpty()){
             System.debug('In acc Data'+accData);
            for(Contact c : accData){
                 System.debug(c.AccountId+' Map '+c.Primary_Contact__c);
                checkData.put(c.AccountId, c.Primary_Contact__c);
            }
            for(Contact c:conList){
                if(c.AccountId!=null && c.Primary_Contact__c==true && checkData.containsKey(c.AccountId))
                    c.addError('Only one prmary contact Allowed');
            }
        }
    
    }

   }
     
   

}