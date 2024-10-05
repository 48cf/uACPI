#pragma once

#include <uacpi/internal/types.h>
#include <uacpi/kernel_api.h>

uacpi_bool uacpi_this_thread_owns_aml_mutex(uacpi_mutex*);

uacpi_status uacpi_acquire_aml_mutex(uacpi_mutex*, uacpi_u16 timeout);
uacpi_status uacpi_release_aml_mutex(uacpi_mutex*);

static inline uacpi_status uacpi_acquire_native_mutex(uacpi_handle mtx)
{
    if (uacpi_unlikely(mtx == UACPI_NULL))
        return UACPI_STATUS_INVALID_ARGUMENT;

    return uacpi_kernel_acquire_mutex(mtx, 0xFFFF);
}

uacpi_status uacpi_acquire_native_mutex_with_timeout(
    uacpi_handle mtx, uacpi_u16 timeout
);

static inline uacpi_status uacpi_release_native_mutex(uacpi_handle mtx)
{
    if (uacpi_unlikely(mtx == UACPI_NULL))
        return UACPI_STATUS_INVALID_ARGUMENT;

    uacpi_kernel_release_mutex(mtx);
    return UACPI_STATUS_OK;
}

static inline uacpi_status uacpi_acquire_native_mutex_may_be_null(
    uacpi_handle mtx
)
{
    if (mtx == UACPI_NULL)
        return UACPI_STATUS_OK;

    return uacpi_kernel_acquire_mutex(mtx, 0xFFFF);
}

static inline uacpi_status uacpi_release_native_mutex_may_be_null(
    uacpi_handle mtx
)
{
    if (mtx == UACPI_NULL)
        return UACPI_STATUS_OK;

    uacpi_kernel_release_mutex(mtx);
    return UACPI_STATUS_OK;
}
