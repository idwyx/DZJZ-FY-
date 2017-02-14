﻿using System;
using System.Data;
using System.Collections.Generic;
namespace EDRS.IDAL
{
	/// <summary>
    /// 律师案件文件分配
	/// </summary>
    public interface IYX_DZJZ_LSAJWJFP : ILogBase
	{
		#region  成员方法
		/// <summary>
		/// 是否存在该记录
		/// </summary>
		bool Exists(string FPBM);
		/// <summary>
		/// 增加一条数据
		/// </summary>
		bool Add(EDRS.Model.YX_DZJZ_LSAJWJFP model);
        /// <summary>
        /// 增加多条数据
        /// </summary>
        bool AddList(List<EDRS.Model.YX_DZJZ_LSAJWJFP> modelList, EDRS.Model.YX_DZJZ_LSAJBD lsajbdModel, string yjxh);
		/// <summary>
		/// 更新一条数据
		/// </summary>
		bool Update(EDRS.Model.YX_DZJZ_LSAJWJFP model);
		/// <summary>
		/// 删除一条数据
		/// </summary>
		bool Delete(string FPBM);
		/// <summary>
		/// 得到一个对象实体
		/// </summary>
		EDRS.Model.YX_DZJZ_LSAJWJFP GetModel(string FPBM);
		EDRS.Model.YX_DZJZ_LSAJWJFP DataRowToModel(DataRow row);
		/// <summary>
		/// 获得数据列表
		/// </summary>
        DataSet GetList(string strWhere, params object[] objValues);
        /// <summary>
        /// 分页获取数据列表
        /// </summary>
        int GetRecordCount(string strWhere, params object[] objValues);
        /// <summary>
        /// 分页获取数据列表
        /// </summary>
        DataSet GetListByPage(string strWhere, string orderby, int startIndex, int endIndex, params object[] objValues);
		/// <summary>
		/// 根据分页获得数据列表
		/// </summary>
		//DataSet GetList(int PageSize,int PageIndex,string strWhere);
		#endregion  成员方法
		#region  MethodEx

		#endregion  MethodEx
	} 
}
