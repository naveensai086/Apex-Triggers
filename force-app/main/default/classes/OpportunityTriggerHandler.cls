public with sharing class OpportunityTriggerHandler {
    public static void  calTotalAmountOfAccountAfterInsertAndUndelete(List<Opportunity> oppNewList) {

        Set<Id> accIds = new Set<Id>(); 
        if(!oppNewList.isEmpty()){
           for(Opportunity opp : oppNewList){
            if(opp.AccountId!=null)
              accIds.add(opp.AccountId);
           }
         }      
         List<Account> accListForCalc = [select Id , Name,Oppor_Amount__c ,(select Id ,Amount from Opportunities) from Account where Id=:accIds];
         List<Account> accList = new List<Account>();

         if(!accListForCalc.isEmpty()){
            for(Account acc : accListForCalc){
                Decimal total=0;
                for(Opportunity opp :acc.Opportunities ){
                    if(opp.Amount!=Null)
                   total=total+opp.Amount;
                }
                acc.Oppor_Amount__c=total;
                accList.add(acc);
            }  
         }

         if(!accList.isEmpty())
         update accList;
    }

    public static void  calcTotalAmountOfAccountsOpporAfterdelete(List<Opportunity> oppOldList) {
    Set<Id> accIds = new Set<Id>(); 
    if(!oppOldList.isEmpty()){
       for(Opportunity opp : oppOldList){
        if(opp.AccountId!=null)
          accIds.add(opp.AccountId);
       }
     } 
     
     Map<Id,Account> updateAccMap = new Map<Id,Account>();
     if(!accIds.isEmpty()){
        AggregateResult [] groupedResults = [select AccountId ,SUM(Amount) Amount from Opportunity where AccountId IN :accIds group by AccountId];
       if(!groupedResults.isEmpty()){
        for (AggregateResult ar : groupedResults)  {
            Account acc = new Account();
            acc.Id=(Id)ar.get('AccountId');
            acc.Oppor_Amount__c=(Decimal)ar.get('Amount');
            updateAccMap.put(acc.Id,acc);
        }
       }
     }else{
        for (Id var : accIds) {
            Account acc = new Account();
            acc.Id=var;
            acc.Oppor_Amount__c=0;
            updateAccMap.put(acc.Id,acc);
        }
     }

     if(!updateAccMap.isEmpty())
    update updateAccMap.values();


    }

    public static void calcTotalAmountOfAccountsOpporAfterUpdate (List<Opportunity> oppList,Map<Id,Opportunity> oppOldMap) {
        Set<Id> accIds = new Set<Id>(); 
        if(!oppList.isEmpty()){
           for(Opportunity opp : oppList){
            if((opp.AccountId==null && oppOldMap.get(opp.Id).AccountId!=null) || (opp.AccountId!=null && opp.AccountId!=oppOldMap.get(opp.Id).AccountId) ){
                if(opp.AccountId!=null) 
                accIds.add(opp.AccountId);
                if(oppOldMap.get(opp.Id).AccountId!=null)
                accIds.add(oppOldMap.get(opp.Id).AccountId); 
            }
            else {
                if(opp.Amount!=oppOldMap.get(opp.Id).Amount)
                accIds.add(opp.AccountId);
            }
           
           }
         } 

          List<Account> updateAccList = new List<Account>();
         if(!accIds.isEmpty()){
            AggregateResult [] groupedResults = [select AccountId ,SUM(Amount) Amount from Opportunity where AccountId IN :accIds group by AccountId];
            for (AggregateResult ar : groupedResults)  {
                Account acc = new Account();
                acc.Id=(Id)ar.get('AccountId');
                acc.Oppor_Amount__c=(Decimal)ar.get('Amount');
               updateAccList.add(acc);
            }

         }

         if(!updateAccList.isEmpty())
        update updateAccList;


    }
}
