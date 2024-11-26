local Config = require('config')

-- require('utils.backdrops')
--    :set_files()
--    -- :set_focus('#000000')
--    :random()

require('tabs.left_status').setup()
require('tabs.right_status').setup()
require('tabs.tab_title').setup()
-- require('events.new-tab-button').setup()

return Config:init()
   :append(require('config.appearance'))
   :append(require('config.bindings'))
   -- :append(require('config.domains'))
   :append(require('config.fonts'))
   :append(require('config.general'))
   :append(require('config.launch')).options

