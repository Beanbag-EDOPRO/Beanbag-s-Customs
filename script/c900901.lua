local s,id=GetID()
function s.initial_effect(c)
	--Ritual Summon
	Ritual.AddProcGreater({handler=c,filter=s.ritualfil,lvtype=RITPROC_GREATER,sumpos=POS_FACEUP,location=LOCATION_HAND+LOCATION_GRAVE})
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_GEMINI))
	e1:SetCode(EFFECT_GEMINI_STATUS)
	c:RegisterEffect(e1)
end

function s.ritualfil(c)
	return c:IsSetCard(0x4D3) and c:IsRitualMonster()
end