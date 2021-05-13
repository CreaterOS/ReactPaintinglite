Pod::Spec.new do |spec|
  spec.name         = "Paintinglite"
  spec.version      = "2.1.0"
  spec.source       = { :git => "https://github.com/CreaterOS/Paintinglite.git", :tag => "2.1.0" } 
  spec.source_files = "{Paintinglite/Paintinglite/Paintinglite/*},{Paintinglite/Paintinglite/Paintinglite/aes/*},{Paintinglite/Paintinglite/Paintinglite/Cache/*},{Paintinglite/Paintinglite/Paintinglite/Configuration/*},,{Paintinglite/Paintinglite/Paintinglite/Exception/*},{Paintinglite/Paintinglite/Paintinglite/minizip/*},{Paintinglite/Paintinglite/Paintinglite/Opt/*},{Paintinglite/Paintinglite/Paintinglite/Vender/*}"
  spec.summary      = "Paintinglite SDK"
  spec.homepage    = "https://github.com/CreaterOS/Paintinglite.git"
  spec.author       = {"CreaterOS" => "863713745@qq.com"}
  spec.platform     = :ios, "9.0"
end
