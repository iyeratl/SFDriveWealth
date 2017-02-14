<aura:application extends="force:slds">
    <aura:attribute name="recordId" type="Id" default="00141000007RP8r" />
    <aura:attribute name="debug" type="Boolean" default="true" />
    <aura:attribute name="debugClient" type="Boolean" default="true" />
    <c:DWCreateMarketOrder debug="{!v.debug}" recordId="{!v.recordId}" debugClient="{!v.debugClient}" />
</aura:application>