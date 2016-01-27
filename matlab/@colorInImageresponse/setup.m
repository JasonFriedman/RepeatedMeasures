% SETUP - make any changes that need to be made to thistrial before starting the event

function thistrial = setup(r,thistrial)

thistrial.pressedTime = NaN;

if isempty(r.showPositionFeedback)
    thistrial.showPositionFeedback = [];
else
    thistrial.showPositionFeedback = r.showPositionFeedback;
    thistrial.showPositionFeedback(:,3:4) = NaN;
end

