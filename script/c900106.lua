local s,id=GetID()
function s.initial_effect(c)
	--Xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_ROCK),3,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.xcon1)
    e1:SetCost(s.xcost)
	e1:SetTarget(s.xtg)
	e1:SetOperation(s.xop)
	c:RegisterEffect(e1)
end
function s.xcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.xfilter(c,tp)
	return c:IsSetCard(0x385) and c:IsMonster() and c:IsReleasable() and not c:IsCode(id)
end
function s.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.xfilter,1,true,nil,nil,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,s.xfilter,1,1,true,nil,nil,tp)
	Duel.Release(g,REASON_COST)
end
function s.xfilter2(c)
	return c:IsSetCard(0x385) and c:IsMonster() and c:IsAbleToHand()
end
function s.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.xfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.xfilter2,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,LOCATION_GRAVE)
end
function s.xop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectMatchingCard(tp,s.xfilter2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end