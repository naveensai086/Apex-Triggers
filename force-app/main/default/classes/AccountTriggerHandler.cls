public with sharing class AccountTriggerHandler {
   
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