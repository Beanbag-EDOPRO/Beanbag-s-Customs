--lol
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3D),2,2,Synchro.NonTunerEx(Card.IsSetCard,0x3D),1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetLocation(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x3D) and c:IsAbleToRemoveAsCost()
end
function s.filter(c)
	return c:IsSetCard(0x3D) and c:IsType(TYPE_TUNER) and c:IsSummonable(true,nil)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	local dg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	local ct=math.min(2,dg:GetClassCount(Card.GetCode))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,ct,e:GetHandler())
	local rc=Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetTargetParam(rc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,rc,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if dg:GetClassCount(Card.GetCode)==0 or dg:GetClassCount(Card.GetCode)<ct then return end
	local g=Group.CreateGroup()
	for i=1,ct do
		local tc=dg:Select(tp,1,1,nil):GetFirst()
		g:AddCard(tc)
		dg:Remove(Card.IsCode,nil,tc:GetCode())
	end
	Duel.SpecialSummon(g,nil,REASON_EFFECT)
end
