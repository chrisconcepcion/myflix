CarrierWave.configure do |config|
 	config.fog_credentials = {
   	:provider               => 'AWS',                      
   	:aws_access_key_id      => 'AKIAJQROTHIR2XU2N52Q',                    
   	:aws_secret_access_key  => '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',    
  }
  config.fog_directory  = 'MyFlix'                     
end