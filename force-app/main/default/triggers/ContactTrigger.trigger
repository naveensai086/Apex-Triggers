trigger ContactTrigger on Contact (after update,after insert,after Delete,after Undelete,Before insert) {
      
    if(Trigger.isUpdate && Trigger.isAfter){
        ContactTriggerHandler.updateAccountDesc(Trigger.new, Trigger.oldMap);
        ContactTriggerHandler.updateTotalContactsAfterContactUpdate(Trigger.new, Trigger.oldMap);
    }

    if((Trigger.isInsert || Trigger.isUndelete ) && Trigger.isAfter){
        ContactTriggerHandler.updateTotalContactsAfterInsertAndAfterUndelete(Trigger.new);
    }
    
    if(Trigger.isDelete && Trigger.isAfter){
        ContactTriggerHandler.updateTotalContactsAfterDelete(Trigger.old);
    }

    if(Trigger.isInsert  && Trigger.isBefore){
        ContactTriggerHandler.primaryContactCheck(Trigger.new,null);
    }
}