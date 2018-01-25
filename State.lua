State = {}

State.paused = true
State.inventoryView = false

function State.toggle(state)
  if state == "paused" then
    State.paused = not State.paused
    State.inventoryView = false
  elseif state == "inventoryView" then
    State.inventoryView = not State.inventoryView
    State.paused = State.inventoryView
  end
end