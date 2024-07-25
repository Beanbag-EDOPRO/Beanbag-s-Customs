--lol
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3D),2,2,Synchro.NonTunerEx(Card.IsSetCard,0x3D),1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(s.thcost)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.GetLocationCount(tp,LOCATION_GRAVE)>4
	local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,nil)
	if chk==0 then return #rg>1 and aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),0) end
	local g=aux.SelectUnselectGroup(rg,e,tp,2,2,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function s.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x3D) and c:IsAbleToRemoveAsCost()
end
function s.filter(c)
	return c:IsSetCard(0x3D) and c:IsType(TYPE_TUNER) and c:IsSummonable(true,nil)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	if #g>1 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
