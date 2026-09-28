// libm6_camera_tsf_bypass.so: camera TSF bypass (LD_PRELOAD).
//
// Without TSF/LSC calibration data in NVRAM, the MediaTek ISP online
// lens-shading (TSF) runs with a NULL calibration table and crashes the camera
// HAL host shortly after preview starts.
//
// libcamalgo is built without -Bsymbolic, so its calls go through the PLT and
// LD_PRELOAD can override them. The whole online TSF subtree is stubbed at
// TsfCore::TsfCoreProcess(); AppTsf::TsfMain() then only runs its epilogue.
// The camera works without TSF lens-shading refinement.
//
// Mangled members of the stock blob (libcamalgo.so):
//   TsfCore::TsfCoreProcess()                              _ZN7TsfCore14TsfCoreProcessEv
//   TsfCore::Shading_TSF_int_gain(void*,int,int,int*,int*) _ZN7TsfCore20Shading_TSF_int_gainEPviiPiS1_
//   isEnableTSF(int)                                       _Z11isEnableTSFi

extern "C" {

// TsfCore::TsfCoreProcess() — stub the entire per-frame TSF core. x0=this.
int _ZN7TsfCore14TsfCoreProcessEv(void* /*thiz*/) { return 0; }

// TsfCore::Shading_TSF_int_gain(...) — kept as a defensive neutral-gain stub in
// case any other path reaches it. x0=this,x1=void*,x2/x3=int,x4/x5=int* outputs.
int _ZN7TsfCore20Shading_TSF_int_gainEPviiPiS1_(
        void* /*thiz*/, void* /*a1*/, int /*a2*/, int /*a3*/, int* o1, int* o2)
{ if (o1) *o1 = 1024; if (o2) *o2 = 1024; return 0; }

int _Z11isEnableTSFi(int /*sensorId*/) { return 0; }

}
