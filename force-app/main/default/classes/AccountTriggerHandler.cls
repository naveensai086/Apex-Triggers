public with sharing class AccountTriggerHandler {
   
    public static void preventDuplicateRecord(List<Account> accList){

            if (accList.isEmpty()) {
                return;
            }
            // Collect unique account names (normalized to lowercase)
            
            Set<String> newAccNames = new Set<String>();
            Map<String, Id> nameToIdMap = new Map<String, Id>();
            for (Account acc : accList) {
                if (acc.Name != null) {
                    newAccNames.add(acc.Name.toLowerCase());
                }
                if(acc.Id!=null){
                    nameToIdMap.put(acc.Name,acc.Id);
                }
            }
            // Query existing accounts with names in the set
        
            List<Account> existingAccounts = [SELECT Id, Name FROM Account WHERE Name IN :newAccNames];
            Set<String> existingAccNames = new Set<String>();
            Map<String, Id> existingNameToIdMap = new Map<String, Id>();

            for (Account acc : existingAccounts) {
                existingAccNames.add(acc.Name.toLowerCase());
                existingNameToIdMap.put(acc.Name.toLowerCase(),acc.Id);
            }
        
            // Flag duplicate records
            for (Account acc : accList) {
                if (acc.Name != null && existingAccNames.contains(acc.Name.toLowerCase())) {
                    if(!existingNameToIdMap.get(acc.Name.toLowerCase()).equals(acc.Id))
                    acc.addError('Duplicate Record Name '+acc.Name);
                }
            }
    }


    public static void updateContactsWithAccountPhone(List<Account> accList , map<Id,Account> accOldMap){
         Map<Id,Account> accMap = new Map<Id,Account>();
        for(Account acc :accList){
            if(acc.Phone != accOldMap.get(acc.Id).Phone){
                accMap.put(acc.Id,acc);
            }
        }

        List<Contact> conList = [select AccountId ,Id,Phone from Contact where AccountId=:accMap.keySet()];
        List<Contact> contListToUpdate= new List<Contact>();
        if(!conList.isEmpty()){
           for (Contact con  : conList) {
               con.Phone=accMap.get(con.AccountId).Phone;
               contListToUpdate.add(con);
           }
        }

        if(!contListToUpdate.isEmpty())
        update contListToUpdate;
       
    }
}