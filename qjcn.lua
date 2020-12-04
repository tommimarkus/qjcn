function qjcn_OnLoad(self, event, ...)
    self:RegisterEvent("ADDON_LOADED")
end

function qjcn_OnEvent(self, event, ...)
    if event == "ADDON_LOADED" and ... == "qjcn" then
        self:UnregisterEvent("ADDON_LOADED")
        self:RegisterEvent("SOCIAL_QUEUE_UPDATE")
    end
    if event == "SOCIAL_QUEUE_UPDATE" then
        local groupGUID, numAddedItems = ...
        if not groupGUID or numAddedItems == 0 then
            return
        end

        local groupMembers = C_SocialQueue.GetGroupMembers(groupGUID)
        if not groupMembers then
            return
        end

        local firstGroupMember = groupMembers[1]
        if not firstGroupMember then return end

        local groupMemberName, groupMemberColor, groupMemberRelationship, groupMemberPlayerLink =
            SocialQueueUtil_GetRelationshipInfo(firstGroupMember.guid, nil, firstGroupMember.clubId)
        local _, groupMemberClass = GetPlayerInfoByGUID(firstGroupMember.guid)
        if not groupMemberClass then return end
        local classColor = C_ClassColor.GetClassColor(groupMemberClass)
        if not groupMemberName or
            not groupMemberColor or
            not groupMemberRelationship or
            not classColor then
                return
        end
        
        local queues = C_SocialQueue.GetGroupQueues(groupGUID)
        if not queues then return end

        for _, queue in pairs(queues) do
            if queue.queueData then
                local activityName = SocialQueueUtil_GetQueueName(queue.queueData)
                if activityName and activityName ~= UNKNOWNOBJECT then
                    print(
                        format("|cffCCCC00qjcn:|r %s(%s)|r %s |cffFFFFFFqueued for|r |cff00CCCC%s|r",
                            groupMemberColor,
                            groupMemberRelationship,
                            classColor:WrapTextInColorCode(groupMemberName),
                            activityName
                        )
                    )
                end
            end
        end
    end
end
