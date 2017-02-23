trigger DWAccount on Account (before insert, before update) {

    if(Trigger.isBefore && Trigger.isInsert){
        //Run on Account Before
        if(DWTriggerRecursiveCheck.hasRun('DWAccount_Before_Insert') == false) {

            DWAccountTriggerHandler.handleBeforeInsert(Trigger.new);

            DWTriggerRecursiveCheck.markAsRun('DWAccount_Before_Insert');
        }
    }else if(Trigger.isBefore && Trigger.isUpdate){
        //Run on Account After
        if(DWTriggerRecursiveCheck.hasRun('DWAccount_Before_Update') == false) {

            DWAccountTriggerHandler.handleBeforeUpdate(Trigger.new,  Trigger.newMap, Trigger.oldMap);

            DWTriggerRecursiveCheck.markAsRun('DWAccount_Before_Update');
        }
    }
}