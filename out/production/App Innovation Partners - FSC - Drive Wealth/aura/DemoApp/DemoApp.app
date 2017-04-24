<aura:application extends="force:slds">
    <aura:attribute name="recordId" type="Id" default="00141000007RP8w" />
    <aura:attribute name="debug" type="Boolean" default="true" />
    <aura:attribute name="debugClient" type="Boolean" default="true" />
    <c:DWCreateMarketOrder debug="{!v.debug}" recordId="{!v.recordId}" debugClient="{!v.debugClient}" />
    <!--<c:DWSearchInstrument debug="{!v.debug}" debugClient="{!v.debugClient}" recordId="{!v.recordId}" fireEvtInstrumentInfo="false" />-->
</aura:application>