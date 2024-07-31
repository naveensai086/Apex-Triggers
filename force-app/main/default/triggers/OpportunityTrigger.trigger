trigger OpportunityTrigger on Opportunity (after insert,after update , after delete,after undelete) {


    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUndelete)){
        OpportunityTriggerHandler.calTotalAmountOfAccountAfterInsertAndUndelete(Trigger.new);
    }

    if(Trigger.isAfter && Trigger.isDelete){
        OpportunityTriggerHandler.calcTotalAmountOfAccountsOpporAfterdelete(Trigger.old);
    }

    if(Trigger.isAfter && Trigger.isUpdate){
        OpportunityTriggerHandler.calcTotalAmountOfAccountsOpporAfterUpdate(Trigger.new,Trigger.oldMap);
    }
}