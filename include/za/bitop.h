/*
 *	libza
 *	/include/za/bitop.h
 *	SPDX-License-Identifier: MPL-2.0
 *	Copyright (c) 2024 Yao Zi <ziyao@disroot.org>
 */

#ifndef __ZA_BITOP_H_INC__
#define __ZA_BITOP_H_INC__

/*
	TODO: replace generic implementation with platform-specific ones
*/

#define za_bit_set(v, b)	(v) |= (1 << (b))
#define za_bit_clr(v, b)	(v) &= ~(1 << (b))
#define za_bit_get(v, b)	(v) & (1 << (b))
#define za_bit_getone(v, b)	(((v) >> (b)) & 1)

#endif	// __ZA_BITOP_H_INC__
