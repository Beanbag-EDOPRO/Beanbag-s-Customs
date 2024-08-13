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
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.xyztg)
	e2:SetOperation(s.xyzop)
	c:RegisterEffect(e2)
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
end

function s.filter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x385) and c:IsCanBeEffectTarget(e)
end
function s.xyzfilter(c,mg,tp,chk)
	return c:IsXyzSummonable(nil,mg,2,2) and (not chk or Duel.GetLocationCountFromEx(tp,tp,mg,c)>0) and c:IsSetCard(0x385)
end
function s.zonecheck(c,tp,g)
	return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and c:IsXyzSummonable(nil,g)
end
function s.mfilter1(c,mc,exg,tp)
	local g=Group.FromCards(c,mc)
	return exg:IsExists(s.zonecheck,1,nil,tp,g)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil,e)
	local exg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return mg:IsExists(s.mfilter1,1,nil,mg,exg,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg1=mg:FilterSelect(tp,s.mfilter1,1,1,nil,mg,exg,tp)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.tfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.tfilter,nil,e)
	if #g<1 then return end
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,g,tp,true)
	if #xyzg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,nil,g)
	end
end