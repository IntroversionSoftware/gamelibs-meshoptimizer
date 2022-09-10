// This file is part of meshoptimizer library; see meshoptimizer.h for version/license details
#include "meshoptimizer.h"

meshopt_alloc_t meshopt_Allocator::Storage::allocate = operator new;
meshopt_dealloc_t meshopt_Allocator::Storage::deallocate = operator delete;

void meshopt_setAllocator(void* (MESHOPTIMIZER_ALLOC_CALLCONV *allocate)(size_t), void (MESHOPTIMIZER_ALLOC_CALLCONV *deallocate)(void*))
{
	meshopt_Allocator::Storage::allocate = allocate;
	meshopt_Allocator::Storage::deallocate = deallocate;
}
