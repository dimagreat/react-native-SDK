import * as t from 'io-ts';
/**
 * Used for Event Listeners
 * AdInfo params:
 * https://developers.is.com/ironsource-mobile/android/levelplay-listener-adinfo-integration/#step-3
 */
export declare const placementAdInfoCodec: t.TypeC<{
    placement: t.TypeC<{
        placementName: t.StringC;
        rewardName: t.StringC;
        rewardAmount: t.NumberC;
    }>;
    adInfo: t.TypeC<{
        auctionId: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        adUnit: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        adNetwork: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        instanceName: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        instanceId: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        country: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        revenue: t.UnionC<[t.Type<number, any, any>, t.UndefinedC]>;
        precision: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        ab: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        segmentName: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        encryptedCPM: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
    }>;
}>;
export declare const errorAdInfoCodec: t.TypeC<{
    error: t.TypeC<{
        errorCode: t.NumberC;
        message: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
    }>;
    adInfo: t.TypeC<{
        auctionId: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        adUnit: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        adNetwork: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        instanceName: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        instanceId: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        country: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        revenue: t.UnionC<[t.Type<number, any, any>, t.UndefinedC]>;
        precision: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        ab: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        segmentName: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
        encryptedCPM: t.UnionC<[t.Type<string, any, any>, t.UndefinedC]>;
    }>;
}>;
