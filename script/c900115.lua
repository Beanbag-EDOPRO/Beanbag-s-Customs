--Magmalith Brimstone
--scripted by Beanbag
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.sendactivate)
	c:RegisterEffect(e1)
end
function s.sendfilter(c,tp)
	return c:IsSetCard(0x385) and c:IsMonster() and c:IsReleasable()
end
function s.sendfilter2(c)
	return c:IsSetCard(0x385) and c:IsMonster() and c:IsAbleToGrave()
end
function s.sendactivate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.sendfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if #g==0 or not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:Select(tp,1,1,nil)
	if #tg>0 then
	Duel.Release(tg,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.sendfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if #g>0 then
	Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
