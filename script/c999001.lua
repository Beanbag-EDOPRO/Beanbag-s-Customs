--Holysphere Congregation
--Scripted by Beanbag (Aimer was here)

local s,id=GetID()
function s.initial_effect(c)
	--Activate
	Ritual.AddProcGreater{handler=c,filter=s.ritualfil,matfilter=s.matfilter,extrafil=s.extragroup,extraop=s.extraop,forcedselection=s.tributelimit,stage2=s.stage2}
	--Return to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id)	
    e2:SetTarget(s.rthtg)
	e2:SetOperation(s.rthop)
	c:RegisterEffect(e2)
end

s.listed_series={0x270F}
s.listed_names={999000}

--Material Filters
function s.ritualfil(c)
    return c:IsSetCard(0x270F) and c:IsRitualMonster()
end
function s.matfilter(c)
    return c:IsReleasableByEffect() and c:IsMonster() and c:IsCanBeRitualMaterial() and ((c:IsSetCard(0x270F) and c:IsLocation(LOCATION_DECK)) or (c:IsLocation(LOCATION_HAND|LOCATION_MZONE)))
end
function s.deckmatfilter(c)
    return c:IsSetCard(0x270F) and c:IsReleasableByEffect() and c:IsCanBeRitualMaterial()
end

--Return Handlimit is above 0/Different name check function
function s.extragroup(e,tp,eg,ep,ev,re,r,rp,chk)
    local handlim=6
    local hls=Duel.GetPlayerEffect(tp,EFFECT_HAND_LIMIT)
    if hls then
        handlim=hls:GetValue()
    end
    if handlim<=0 then return end
    local g=Duel.GetMatchingGroup(s.deckmatfilter,tp,LOCATION_DECK,0,nil)
    local newgroup=Group.CreateGroup()
    local nametable={}
    for tc in aux.Next(g) do
        local name=tc:GetCode()
        if not nametable[name] then
            nametable[name]=true
            newgroup:AddCard(tc)
        end
    end
    return newgroup
end

--Release Extra Group from Deck
function s.extraop(mat,e,tp,eg,ep,ev,re,r,rp,tc)
    local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
    mat:Sub(mat2)
    Duel.ReleaseRitualMaterial(mat)
    Duel.SendtoGrave(mat2,REASON_EFFECT|REASON_MATERIAL|REASON_RITUAL|REASON_RELEASE)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end


--Force Allow Deck Materials up to your Handlimit Size
function s.tributelimit(e,tp,g,sc)
	-- Get the hand limit or set it to 6 by default
    local handlim=6
    local hls=Duel.GetPlayerEffect(tp,EFFECT_HAND_LIMIT)
    if hls then
        handlim=hls:GetValue()
    end
    local deckmat=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	return #deckmat<=handlim,#deckmat>handlim
end

--Lose LP equal to # Sent from Deck*500
function s.stage2(mg,e,tp,eg,ep,ev,re,r,rp,sc)
    -- Get the hand limit or set it to 6 by default
    local c=e:GetHandler()
    local handlim=6
    local hls=Duel.GetPlayerEffect(tp,EFFECT_HAND_LIMIT)
    if hls then
        handlim=hls:GetValue()
    end
    local ct=mg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_DECK)
    if ct>0 then 
        Duel.SetLP(tp,Duel.GetLP(tp)-(ct*500))
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_HAND_LIMIT)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetTargetRange(1,0)
        e1:SetValue(handlim-ct)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end


--Return to hand
function s.rthfilter(c)
	return c:IsSetCard(0x270F) and c:IsMonster() and c:IsAbleToDeck()
end
function s.rthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.rthfilter(chkc) end
	if chk==0 then return c:IsAbleToHand() and Duel.IsExistingTarget(s.rthfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.rthfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.rthop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end