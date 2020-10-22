Events:Subscribe('Level:RegisterEntityResources', function()
	ModifyMAV()
end)

Events:Subscribe('Level:LoadResources', function()
	-- Mount SuperBundle of Bandar Desert (Or any map with a tank in it)
	ResourceManager:MountSuperBundle('levels/xp3_desert/xp3_desert')
end)

Hooks:Install('ResourceManager:LoadBundles', 100, function(hook, bundles, compartment)
    if #bundles == 1 and bundles[1] == SharedUtils:GetLevelName() then
        print('Injecting bundles.')

		-- Inject xp3_desert and the tank superiority gamemode so we have a tank available to us
        bundles = {
			'levels/xp3_desert/xp3_desert',
			'levels/xp3_desert/tanksuperiority',
			bundles[1],
        }

        hook:Pass(bundles, compartment)
    end
end)

function ModifyMAV()
	-- Get the WeaponFiringDataAsset for the tank cannon
	local tankWeaponFiringAsset = WeaponFiringDataAsset(ResourceManager:SearchForDataContainer("Vehicles/common/WeaponData/spec/mbt_cannon_firing_t90"))

	-- Get the WeaponComponentData for the MAV's Jammer and make it writable
	local mavWeaponComponentData = WeaponComponentData(ResourceManager:SearchForInstanceByGuid(Guid('AE16B607-51EC-4F90-823C-5C290726ACC6')))
	mavWeaponComponentData:MakeWritable()

	-- Replace the component data's weaponFiring property with a clone of our tank cannon 
	mavWeaponComponentData.weaponFiring = WeaponFiringData(tankWeaponFiringAsset.data:Clone())
end